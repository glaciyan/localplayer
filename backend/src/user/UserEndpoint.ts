import { Elysia, status } from "elysia";
import userController from "./user.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { sessionController } from "../authentication/session/session.ts";

const log = mklog("user-api");

export const UserEndpoint = new Elysia({ prefix: "/user" })
    .use(AuthService)
    .get(
        "/:id",
        async ({ params: { id }, user }) => {
            log.http(`Get user request from user ${user.username}`);
            const requestedUser = await userController.getPublicUser(id);
            if (requestedUser === null) {
                return status(404, "User Not Found");
            }

            return requestedUser;
        },
        {
            cookie: "session",
            requireSession: true,
        }
    )
    // TODO this point can be attacked, add rate limiting
    .post(
        "/signup",
        async ({ body }) => {
            await userController.register(body.name, body.password);
            return status(200);
        },
        {
            body: "userAuth",
        }
    )
    .post(
        "/login",
        async ({ body, cookie: { id } }) => {
            // make sure user is not logged on
            if (id.value) {
                const session = await sessionController.getSession(id.value);
                // user could have a session id cookie but we have restarted our server
                if (session) {
                    // TODO refresh session
                    log.http(
                        `Session ${id.value} (user: ${session.user.username}) tried logging in but was already logged on`
                    );
                    return status(
                        403,
                        "You are already loggin in, please log out first"
                    );
                }
            }

            const goodLogin = await userController.authenticateUser(
                body.name,
                body.password
            );

            if (goodLogin === null) {
                return status(401);
            }

            const { sessionToken, expiresOn } = await sessionController.createSession(
                goodLogin.username
            );

            // set cookie
            id.set({
                value: sessionToken,
                // secure: true,
                httpOnly: true,
                sameSite: true,
                expires: expiresOn,
            });

            log.http(
                `User ${goodLogin.username} logged in, returning session id ${sessionToken}`
            );

            return status(200);
        },
        {
            body: "userAuth",
            cookie: "optionalSession",
        }
    )
    .post(
        "/logout",
        async ({ cookie: { id }, user, sessionId }) => {
            log.http(`User ${user.username} is logging off`);

            const success = await sessionController.deleteSessionSecure(
                sessionId
            );

            if (!success) {
                return status(500);
            }

            id.remove();
            return status(200);
        },
        {
            cookie: "session",
            requireSession: true,
        }
    );
