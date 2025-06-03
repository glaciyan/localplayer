import { Elysia } from "elysia";
import { swagger } from "@elysiajs/swagger";
import { mklog } from "./logger.ts";
import { UserEndpoint } from "./user/UserEndpoint.ts";

const log = mklog("main");

const main = async () => {
    log.info("Launching LocalPlayer Backend");

    const port = process.env["SERVER_PORT"] || "3030";
    new Elysia().use(swagger()).use(UserEndpoint).listen(port);

    log.info(`Elysia server running on port ${port}`);
};

main();
