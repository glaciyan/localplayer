import { PrismaClient } from "./generated/prisma/client.ts";
import { mklog } from "./logger.ts";

const log = mklog("prisma");

export const initDatabase = async () => {
    log.info("Creating prisma client");
    const prisma = new PrismaClient({
        log: [
            {
                emit: "event",
                level: "query",
            },
        ],
    });

    if (process.env["DB_LOG"] === "true") {
        prisma.$on("query", (e) => {
            log.debug(`${e.duration}ms ${e.params} ${e.query}`);
        });
    }

    return prisma;
};

export const prisma = await initDatabase();
