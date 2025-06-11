import { Elysia } from "elysia";
import { cron } from "@elysiajs/cron";
import { sessionController } from "./session.ts";
import { mklog } from "../../logger.ts";

const log = mklog("session-cleaning");

export const SessionCleanCrontab = new Elysia().use(
    cron({
        name: "session_clean_up",
        pattern: "*/10 * * * *",
        async run() {
            log.info("Cleaning up sessions");
            await sessionController.cleanSessionStore();
        },
    })
);
