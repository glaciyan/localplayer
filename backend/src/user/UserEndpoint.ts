import { Elysia, status, t } from "elysia";
import userController from "./user.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { sessionController } from "../authentication/session/session.ts";
import { UNAUTHORIZED } from "../errors.ts";

const log = mklog("user-api");

const NOT_SO_SECRET_SECRET = process.env["NOT_SECRET"];
if (!NOT_SO_SECRET_SECRET) {
    log.error("NO SECRET SET!!!!!!!!!!!! SET THE 'NOT_SECRET' ENVIRONMENT VARIABLE!");
    throw "no secret set";
}

export const UserEndpoint = new Elysia({ prefix: "/user" })
    .use(AuthService)
    .post(
        "/signup",
        async ({ body, headers }) => {
            if (headers.not_secret !== NOT_SO_SECRET_SECRET) {
                return status(403);
            }

            const success = await userController.register(
                body.name,
                body.password
            );

            if (!success) {
                return status(433);
            }

            log.info(`Registered new user ${body.name}`);
            return status(200);
        },
        {
            body: "userAuth",
            headers: t.Object({
                not_secret: t.String(),
            }),
        }
    )
    .post(
        "/login",
        async ({ headers, body, cookie: { id } }) => {
            if (headers.not_secret !== NOT_SO_SECRET_SECRET) {
                return status(403, UNAUTHORIZED);
            }
            // make sure user is not logged on
            if (id.value) {
                const session = await sessionController.getSession(id.value);
                // user could have a session id cookie but we have restarted our server
                if (session) {
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
                return status(403, UNAUTHORIZED);
            }

            const { sessionToken, expiresOn } =
                await sessionController.createSession(goodLogin.id);

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
            headers: t.Object({
                not_secret: t.String(),
            }),
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
