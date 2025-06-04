import { prisma } from "../../database.ts";
import { Session, User } from "../../generated/prisma/client.ts";
import { mklog } from "../../logger.ts";
import { ISessionHandler } from "./ISessionHandler.ts";

const log = mklog("session-repo");

export class SessionRepository implements ISessionHandler {
    async getSession(
        secureId: string
    ): Promise<(Session & { user?: User }) | null> {
        const session = await prisma.session.findFirst({
            where: { secureId },
            include: { user: true },
        });

        return session;
    }

    async createSession(
        secureId: string,
        username: string,
        validUntil: Date
    ): Promise<Session> {
        const Session = await prisma.session.create({
            data: { secureId, username, validUntil },
        });

        return Session;
    }

    async deleteSession(id: number) {
        try {
            const session = await prisma.session.delete({ where: { id } });
            return session;
        } catch (e) {
            log.error(`Attempted session delete that was not found id: ${id}`);
            return null;
        }
    }
}
