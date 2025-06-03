import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { mklog } from "./logger.ts";
import { UserEndpoint } from "./user/UserEndpoint.ts";
import { AuthService } from "./authentication/AuthService.ts";

const log = mklog("main");

const PORT = process.env["SERVER_PORT"] || "3030";

const main = async () => {
    log.info("Launching LocalPlayer Backend");

    new Elysia() //
        // .onError(())
        .use(swagger())
        .use(AuthService)
        .use(UserEndpoint)
        .listen(PORT);

    log.info(`Elysia server running on port ${PORT}`);
};

main();
