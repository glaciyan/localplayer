import { Elysia, status } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { mklog } from "./logger.ts";
import { UserEndpoint } from "./user/UserEndpoint.ts";
import { AuthService } from "./authentication/AuthService.ts";
import { swaggerConfig } from "./swagger.ts";
import { UNAUTHORIZED } from "./errors.ts";
import { cors } from "@elysiajs/cors";
import { Prisma } from "./generated/prisma/client.ts";
import { cron } from "@elysiajs/cron";
import { sessionController } from "./authentication/session/session.ts";

const log = mklog("main");

const PORT = process.env["SERVER_PORT"] || "3030";

const main = async () => {
    log.info("Launching LocalPlayer Backend");

    new Elysia() //
        .use(
            cron({
                name: "session_clean_up",
                pattern: "*/1 * * * *",
                async run() {
                    log.info("Cleaning up sessions");
                    await sessionController.cleanSessionStore();
                }
            })
        )
        .onError(({ error, code, path }) => {
            if (code === "INTERNAL_SERVER_ERROR") {
                log.error(
                    `${path} ${error.code} ${error.code} ${error.message}`,
                    {
                        stack: error.stack,
                        cause: error.cause,
                    }
                );
                return status(500);
            }

            if (code === "VALIDATION") {
                if (error.type === "cookie") {
                    log.http(`Unauthorized access on ${path}`);
                    return status(401, UNAUTHORIZED);
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

            if (code === "NOT_FOUND") return;

            if (code === "PARSE") return;

            if (code === "UNKNOWN") {
                log.error(`${path} Unknown Error ${error.message}`, {
                    stack: error.stack,
                    cause: error.cause,
                });
                return status(500);
            }

            if (error instanceof Prisma.PrismaClientKnownRequestError) {
                log.error(error.message);

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
        .use(cors()) // TODO make stricter for production
        .listen(PORT);

    log.info(`Elysia server running on port ${PORT}`);
};

main();
