import { Elysia, status } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { mklog } from "./logger.ts";
import { UserEndpoint } from "./user/UserEndpoint.ts";
import { AuthService } from "./authentication/AuthService.ts";
import { swaggerConfig } from "./swagger.ts";
import { AuthenticationError, CustomValidationError, ErrorTemplates, respond } from "./errors.ts";
import { cors } from "@elysiajs/cors";
import { Prisma } from "./generated/prisma/client.ts";
import { SessionCleanCrontab } from "./authentication/session/SessionCleanCrontab.ts";
import { ProfileEndpoint } from "./profile/ProfileEndpoint.ts";
import { PresenceEndpoint } from "./presence/PresenceEndpoint.ts";
import { SessionEndpoint } from "./session/SessionEndpoint.ts";
import { SwipeEndpoint } from "./swipe/SwipeEndpoint.ts";
import { NotificationEndpoint } from "./notification/NotificationEndpoint.ts";
import { SpotifyEndpoint } from "./spotify/SpotifyEndpoint.ts";
import { PingEndpoint } from "./ping/PingEndpoint.ts";

const log = mklog("main");
const error_handling = mklog("error_handling");

const PORT = process.env["SERVER_PORT"] || "3030";

const main = async () => {
    log.info("Launching LocalPlayer Backend");

    new Elysia() //
        .use(SessionCleanCrontab)
        .error({
            CustomValidationError,
            AuthenticationError
        })
        .onError(({ error, code, path }) => {
            if (code === "INTERNAL_SERVER_ERROR") {
                error_handling.error(
                    `${path} ${error.code} ${error.code} ${error.message}`,
                    {
                        stack: error.stack,
                        cause: error.cause,
                    }
                );
                return respond(ErrorTemplates.INTERNAL_SERVER_ERROR);
            }

            if (code === "AuthenticationError") {
                return error.toResponse();
            }

            if (code === "CustomValidationError") {
                return status(422, {
                    type: "validation",
                    message: error.message,
                });
            }

            if (code === "VALIDATION") {
                if (error.type === "cookie") {
                    error_handling.http(`Unauthorized access on ${path}`);
                    return respond(ErrorTemplates.AUTH_NOSESSION);
                }
                return;
            }

            if (code === "INVALID_COOKIE_SIGNATURE") {
                return status(error.status, {
                    type: "INVALID_COOKIE_SIGNATURE",
                    message: "Invalid Cookie Signature",
                });
            }

            if (code === "INVALID_FILE_TYPE") return;

            if (code === "NOT_FOUND") {
                log.warn(`NOT_FOUND ${path}`);
                return;
            }

            if (code === "PARSE") return;

            if (code === "UNKNOWN") {
                error_handling.error(`${path} Unknown Error ${error.message}`, {
                    stack: error.stack,
                    cause: error.cause,
                });
                return status(500);
            }

            if (error instanceof Prisma.PrismaClientKnownRequestError) {
                error_handling.error(error.message);

                if (error.code === "P2002") {
                    return status(500, "Unique constraint failed");
                }

                return status(500);
            }

            // log.error(`Uncaught error detected ${JSON.stringify(error)}`);
            // return status(500, "Unknown error check logs");
            return;
        })
        .use(swagger(swaggerConfig))
        .use(AuthService)
        .use(UserEndpoint)
        .use(ProfileEndpoint)
        .use(PresenceEndpoint)
        .use(SessionEndpoint)
        .use(SwipeEndpoint)
        .use(NotificationEndpoint)
        .use(SpotifyEndpoint)
        .use(PingEndpoint)
        .use(cors())
        .listen(PORT);

    log.info(`Elysia server running on port ${PORT}`);
};

main();
