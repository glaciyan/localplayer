import { Elysia, status } from "elysia";
import { mklog } from "./logger.ts";

const log = mklog("elysia-errors");

export default new Elysia().onError(({ error, code, path }) => {
    if (code === "INTERNAL_SERVER_ERROR") {
        log.error(`${path} ${error.code} ${error.code} ${error.message}`, {
            stack: error.stack,
            cause: error.cause,
        });
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

    return;
});

export const UNAUTHORIZED = {
    type: "UNAUTHORIZED",
    message: "You need to be logged in to access this endpoint",
};
