import { prisma } from "../database.ts";
import { CustomValidationError } from "../errors.ts";
import { Profile } from "../generated/prisma/client.ts";
import { LPSessionStatus } from "../generated/prisma/enums.ts";
import { mklog } from "../logger.ts";
import { notificationController } from "../notification/notification.ts";
import presenceController from "../presence/presence.ts";

const log = mklog("lpsession-controller");

export const ParticipantInclude = {
    include: {
        fakePresence: true,
    },
} as const;

export const SessionIncludes = {
    presence: {
        omit: {
            id: true,
        },
    },
    creator: {
        include: {
            fakePresence: true,
        },
    },
    participants: {
        include: {
            participant: ParticipantInclude,
        },
    },
} as const;

export class LPSessionService {
    async createSession(
        profileId: number,
        latitude: string,
        longitude: string,
        name: string,
        status: LPSessionStatus
    ) {
        const { lat, lng } = presenceController.convertCoords(
            latitude,
            longitude
        );

        const session = await prisma.lPSession.create({
            data: {
                status: status,
                name: name,
                presence: {
                    create: {
                        latitude: lat,
                        longitude: lng,
                    },
                },
                creator: {
                    connect: {
                        id: profileId,
                    },
                },
            },
            include: SessionIncludes,
        });

        return session;
    }

    async getSession(id: number) {
        return await prisma.lPSession.findUnique({
            where: { id },
            include: SessionIncludes,
        });
    }

    async joinSession(id: number, profile: Profile) {
        const session = await prisma.lPSession.findUnique({
            where: {
                id,
                creatorId: { not: profile.id },
                participants: { none: { participantId: profile.id } },
            },
        });

        if (session === null) {
            log.info(
                "user probably is already the creator or in the participants list"
            );
            throw new CustomValidationError("You are already in this session");
        }

        const request = await prisma.lPSessionParticipation.create({
            data: {
                status: session.status === "OPEN" ? "OPEN_ACCEPTED" : "PENDING",
                participant: {
                    connect: {
                        id: profile.id,
                    },
                },
                session: {
                    connect: {
                        id: id,
                    },
                },
            },
        });

        await notificationController.createNotification({
            from: profile.id,
            to: session.creatorId,
            title: `${
                profile.displayName || profile.handle
            } has requested to join your session`,
            message: null,
            lpSessionId: session.id,
        });

        return {
            createdAt: request.createdAt,
            status: request.status,
        };
    }

    async getIncomingRequests(profileId: number) {
        const session = await prisma.lPSessionParticipation.findMany({
            where: {
                session: {
                    creatorId: profileId,
                },
                status: "PENDING",
            },
            include: {
                participant: ParticipantInclude,
            },
        });

        return session;
    }

    async getSentRequests(profileId: number) {
        const session = await prisma.lPSessionParticipation.findMany({
            where: {
                participantId: profileId,
                // status: "PENDING",
            },
            include: {
                participant: ParticipantInclude,
            },
        });

        return session;
    }

    async respondRequest(
        participantId: number,
        sessionId: number,
        accept: boolean,
        profile: Profile
    ) {
        const participation = await prisma.lPSessionParticipation.update({
            where: { participantId_sessionId: { participantId, sessionId } },
            data: {
                status: accept ? "ACCEPTED" : "DECLINED",
            },
        });

        await notificationController.createNotification({
            from: profile.id,
            to: participantId,
            title: `${
                profile.displayName || profile.handle
            } has accepted your request.`,
            message: null,
            lpSessionId: sessionId,
        });

        return participation;
    }

    async closeSession(sessionId: number) {
        return await prisma.lPSession.update({
            where: { id: sessionId },
            data: {
                status: "CONCLUDED",
            },
        });
    }
}
