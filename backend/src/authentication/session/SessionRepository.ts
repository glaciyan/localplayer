import { prisma } from "../../database.ts";
import { AuthSession as Session, User } from "../../generated/prisma/client.ts";
import { mklog } from "../../logger.ts";
import { ISessionHandler } from "./ISessionHandler.ts";

const log = mklog("session-repo");

export class SessionRepository implements ISessionHandler {
    async getSession(
        secureId: string
    ): Promise<(Session & { user: User }) | null> {
        const session = await prisma.authSession.findFirst({
            where: { secureId },
            include: { user: true },
        });

        return session;
    }

    async createSession(
        secureId: string,
        userId: number,
        validUntil: Date
    ): Promise<Session> {
        const Session = await prisma.authSession.create({
            data: { secureId, userId, validUntil },
        });

        return Session;
    }

    async deleteSession(id: number) {
        try {
            const session = await prisma.authSession.delete({ where: { id } });
            return session;
        } catch (e) {
            log.error(`Attempted session delete that was not found id: ${id}`);
            return null;
        }
    }

    async deleteSessionSecure(secureId: string): Promise<Session | null> {
        try {
            const session = await prisma.authSession.delete({
                where: { secureId },
            });
            return session;
        } catch (e) {
            log.error(
                `Attempted session delete that was not found secure id: ${secureId}`
            );
            return null;
        }
    }

    async deleteExpiredSessions(): Promise<void> {
        const currentTime = new Date();
        await prisma.authSession.deleteMany({
            where: {
                validUntil: {
                    lte: currentTime,
                },
            },
        });
    }
}
