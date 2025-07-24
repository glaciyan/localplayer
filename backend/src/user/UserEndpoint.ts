import { Elysia, t } from "elysia";
import userController from "./user.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { sessionController } from "../authentication/session/session.ts";
import { AuthenticationError, ErrorTemplates, UnknownError } from "../errors.ts";

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
        async ({ body, request }) => {
            if (request.headers.get("not_secret") !== NOT_SO_SECRET_SECRET) {
                log.warn(
                    "Someone tried to access an open endoint without auth."
                );
                throw new AuthenticationError(ErrorTemplates.NO_SECRET);
            }

            await userController.register(body.name, body.password);

            log.info(`Registered new user ${body.name}`);
        },
        {
            body: "userRegister",
            headers: t.Object({
                not_secret: t.String(),
            }),
            requireSecret: true,
        }
    )
    .post(
        "/login",
        async ({ body, request }) => {
            if (request.headers.get("not_secret") !== NOT_SO_SECRET_SECRET) {
                log.warn(
                    "Someone tried to access an open endoint without auth."
                );
                throw new AuthenticationError(ErrorTemplates.NO_SECRET);
            }

            const goodLogin = await userController.authenticateUser(
                body.name.trim(),
                body.password
            );

            if (goodLogin === null) {
                log.error("Wrong username or password " + body.name.trim());
                throw new AuthenticationError(ErrorTemplates.INVALID_CREDENTIALS);
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
            requireSecret: true,
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
                log.error(`unknown error for logging out ${sessionId}`)
                throw new UnknownError();
            }
        },
        {
            requireSession: true,
        }
    );
