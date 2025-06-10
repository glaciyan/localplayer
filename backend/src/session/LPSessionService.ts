import { prisma } from "../database.ts";
import { CustomValidationError } from "../errors.ts";
import { LPSessionStatus } from "../generated/prisma/enums.ts";
import { mklog } from "../logger.ts";
import presenceController from "../presence/presence.ts";

const log = mklog("lpsession-controller");

const ParticipantInclude = {
    include: {
        fakePresence: true,
    },
} as const;

const SessionIncludes = {
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

    async joinSession(id: number, profileId: number) {
        const session = await prisma.lPSession.findUnique({
            where: {
                id,
                creatorId: { not: profileId },
                participants: { none: { participantId: profileId } },
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
                        id: profileId,
                    },
                },
                session: {
                    connect: {
                        id: id,
                    },
                },
            },
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
        accept: boolean
    ) {
        const participation = await prisma.lPSessionParticipation.update({
            where: { participantId_sessionId: { participantId, sessionId } },
            data: {
                status: accept ? "ACCEPTED" : "DECLINED",
            },
        });

        return participation;
    }
}
