import { Elysia, status, t } from "elysia";
import userController from "./user.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { sessionController } from "../authentication/session/session.ts";

const log = mklog("user-api");

const NOT_SO_SECRET_SECRET = process.env["NOT_SECRET"];
if (!NOT_SO_SECRET_SECRET) {
    log.error(
        "NO SECRET SET!!!!!!!!!!!! SET THE 'NOT_SECRET' ENVIRONMENT VARIABLE!"
    );
    throw "no secret set";
}

export const UserEndpoint = new Elysia({ prefix: "/user" })
    .use(AuthService)
    .post(
        "/signup",
        async ({ body, headers }) => {
            if (headers.not_secret !== NOT_SO_SECRET_SECRET) {
                log.warn(
                    "Someone tried to access an open endoint without auth."
                );
                return status(422, "No Secret 'not_secret' set in header");
            }

            await userController.register(
                body.name,
                body.password
            );

            log.info(`Registered new user ${body.name}`);
            return status(200);
        },
        {
            body: "userRegister",
            headers: t.Object({
                not_secret: t.String(),
            }),
        }
    )
    .post(
        "/login",
        async ({ headers, body }) => {
            if (headers.not_secret !== NOT_SO_SECRET_SECRET) {
                log.warn(
                    "Someone tried to access an open endoint without auth."
                );
                return status(403, "No Secret 'not_secret' set in header");
            }

            const goodLogin = await userController.authenticateUser(
                body.name.trim(),
                body.password
            );

            if (goodLogin === null) {
                log.error("Wrong username or password " + body.name.trim())
                return status(403, "Wrong username or password");
            }

            const { sessionToken, expiresOn } =
                await sessionController.createSession(goodLogin.id);

            log.http(
                `User ${goodLogin.username} logged in, returning session id ${sessionToken}`
            );

            return {
                token: sessionToken,
                expires: expiresOn,
            };
        },
        {
            body: "userLogin",
            cookie: "optionalSession",
            headers: t.Object({
                not_secret: t.String(),
            }),
        }
    )
    .post(
        "/logout",
        async ({ user, sessionId }) => {
            log.http(`User ${user.username} is logging off`);

            const success = await sessionController.deleteSessionSecure(
                sessionId
            );

            if (!success) {
                return status(500);
            }

            return status(200);
        },
        {
            requireSession: true,
        }
    );
