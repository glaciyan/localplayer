import base64url from "base64url";
import { ISessionHandler } from "./ISessionHandler.ts";
import { addSeconds } from "date-fns";
import { mklog } from "../../logger.ts";

const log = mklog("session");

const MAX_SESSION_LENGTH = 3600;

export class SessionService {
    handler: ISessionHandler;

    constructor(handler: ISessionHandler) {
        this.handler = handler;
    }

    async createSession(username: string) {
        const buffer = new Uint8Array(16);
        const random = crypto.getRandomValues(buffer);
        const sessionToken = base64url.default(Buffer.from(random));

        const expiresOn = addSeconds(new Date(), MAX_SESSION_LENGTH);

        await this.handler.createSession(sessionToken, username, expiresOn);
        return [sessionToken, expiresOn];
    }

    async getSession(sessionId: string) {
        const session = await this.handler.getSession(sessionId);
        if (session === null) {
            return [false, null];
        }

        const now = new Date();
        if (now > session.validUntil) {
            log.http("Removing expired session");
            this.handler.deleteSession(session.id);
            return [false, session];
        }

        return [true, session];
    }
}
