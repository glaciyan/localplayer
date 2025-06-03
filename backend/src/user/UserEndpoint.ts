import { Elysia, status } from "elysia";
import userController from "./user.ts";
import { createSession } from "../authentication/Session.ts";
import base64url from "base64url";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";

const log = mklog("user-api");

const MAX_SESSION_LENGTH = 3600;

export const UserEndpoint = new Elysia({ prefix: "/user" })
    .use(AuthService)
    .get(
        "/:id",
        async ({ params: { id }, userId }) => {
            log.http(`Get user request from user ${userId}`);
            const user = await userController.getPublicUser(id);
            if (user === null) {
                return status(404, "User Not Found");
            }

            return user;
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
        async ({ body, store, cookie: { id } }) => {
            // make sure user is not logged on
            if (id.value) {
                const session = store.sessions[id.value];
                // user could have a session id cookie but we have restarted our server
                if (session) {
                    log.http(
                        `Session ${id.value} (user: ${session?.userId}) tried logging in but was already logged on`
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

            const buffer = new Uint8Array(16);

            const random = crypto.getRandomValues(buffer);
            const sessionToken = base64url.default(Buffer.from(random));

            store.sessions[sessionToken] = createSession(
                goodLogin.username,
                MAX_SESSION_LENGTH
            );

            id.set({
                value: sessionToken,
                // secure: true,
                httpOnly: true,
                sameSite: true,
                maxAge: MAX_SESSION_LENGTH,
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
        ({ store: { sessions }, cookie: { id }, userId, sessionId }) => {
            log.http(`User ${userId} is logging off`);
            delete sessions[sessionId];
            id.remove();
            return userId;
        },
        {
            cookie: "session",
            requireSession: true,
        }
    );
