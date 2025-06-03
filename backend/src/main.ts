import { mklog } from "./logger.ts";

const log = mklog("main");

const main = async () => {
    log.info("LocalPlayer Backend");
    log.debug("debug");
    log.warn("warn");
    log.error("err");
    log.http("http");
};

main().finally(() => {
    log.info("Shutting down");
});
