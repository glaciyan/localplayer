import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { mklog } from "./logger.ts";
import { UserEndpoint } from "./user/UserEndpoint.ts";
import { AuthService } from "./authentication/AuthService.ts";
import { swaggerConfig } from "./swagger.ts";
import {
    ApiError,
    AuthenticationError,
    CustomValidationError,
    ErrorTemplates,
    NotFoundError,
    ProfileNotFoundError,
    respond,
    UnknownError,
} from "./errors.ts";
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
            AuthenticationError,
            NotFoundError,
            ProfileNotFoundError,
            UnknownError,
            ApiError,
        })
        .onError(({ error, code, path }) => {
            // Prisma errors
            if (error instanceof Prisma.PrismaClientKnownRequestError) {
                error_handling.error(error.message);

                if (error.code === "P2002") {
                    return respond(ErrorTemplates.DB_UNIQUE_CONSTRAINT);
                }

                return respond(ErrorTemplates.DB_QUERY_FAILED);
            }

            if (code === "INTERNAL_SERVER_ERROR") {
                error_handling.error(`${path} INTERNAL ${error.message}`, {
                    stack: error.stack,
                    cause: error.cause,
                });
                return respond(ErrorTemplates.INTERNAL_SERVER_ERROR);
            }

            if (
                code === "AuthenticationError" ||
                code === "CustomValidationError" ||
                code === "NotFoundError" ||
                code === "ProfileNotFoundError" ||
                code === "UnknownError" ||
                code === "ApiError"
            ) {
                return error.toResponse();
            }

            if (code === "VALIDATION") {
                if ((error as any).type === "cookie") {
                    error_handling.http(`Unauthorized access on ${path}`);
                    return respond(ErrorTemplates.AUTH_NOSESSION);
                }

                const fieldErrors: Record<string, string> = {};

                for (const issue of error.all) {
                    log.info(JSON.stringify(issue));
                    if (issue?.summary && issue?.path && issue?.message) {
                        fieldErrors[issue.path.substring(1)] = issue.message;
                    }
                }

                return new CustomValidationError(fieldErrors).toResponse();
            }

            if (code === "INVALID_COOKIE_SIGNATURE") {
                return respond(ErrorTemplates.INVALID_COOKIE_SIGNATURE);
            }

            if (code === "INVALID_FILE_TYPE") {
                return respond(ErrorTemplates.INVALID_FILE_TYPE);
            }

            if (code === "NOT_FOUND") {
                log.warn(`NOT_FOUND ${path}`);
                return respond(ErrorTemplates.NOT_FOUND_ENDPOINT);
            }

            if (code === "PARSE") {
                return respond(ErrorTemplates.PARSE_ERROR);
            }

            if (code === "UNKNOWN") {
                error_handling.error(`${path} Unknown Error ${error.message}`, {
                    stack: error.stack,
                    cause: error.cause,
                });
                return respond(ErrorTemplates.INTERNAL_SERVER_ERROR);
            }

            error_handling.error(
                `Uncaught error detected ${JSON.stringify(error)}`
            );
            return respond(ErrorTemplates.INTERNAL_SERVER_ERROR);
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
