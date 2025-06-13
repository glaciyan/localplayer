import { AuthSession as Session, User } from "../../generated/prisma/client.ts";

export interface ISessionHandler {
    createSession(secureId: string, userId: number, validUntil: Date): Promise<Session>;
    getSession(secureId: string): Promise<(Session & { user: User }) | null>;
    deleteSession(id: number): Promise<Session | null>;
    deleteSessionSecure(secureId: string): Promise<Session | null>;
    deleteExpiredSessions(): Promise<void>;
}