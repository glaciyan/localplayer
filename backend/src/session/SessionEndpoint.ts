import { Elysia, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import lpsessionController from "./session.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { ApiError, AuthenticationError, ErrorTemplates } from "../errors.ts";
import { mklog } from "../logger.ts";

const log = mklog("lpsession");

export const SessionDTOMap = async (session: any) => {
    const base = await SessionDTOMapWithoutParticipants(session);

    const participations = await Promise.all(
        session.participants.map(async (p: any) => ({
            status: p.status,
            participant: await ProfileDTOMap(p.participant),
        }))
    );

    return {
        ...base,
        participations,
    };
};

export const SessionDTOMapWithoutParticipants = async (session: any) => ({
    ...SessionDTOMapWithoutParticipantsAndCreator(session),
    creator: await ProfileDTOMap(session.creator),
});

export const SessionDTOMapWithoutParticipantsAndCreator = (session: any) => ({
    id: session.id,
    createdAt: session.createdAt,
    updateAt: session.updateAt,
    status: session.status,
    name: session.name,
    presence: {
        latitude: session.presence.latitude,
        longitude: session.presence.longitude,
    },
});

export const SessionEndpoint = new Elysia({ prefix: "session" }) //
    .use(AuthService)
    .model({
        sessionParams: t.Object({
            latitude: t.String(),
            longitude: t.String(),
            name: t.String(),
            open: t.Boolean(),
        }),
    })
    .get(
        "/",
        async ({ profile }) => {
            const session = await lpsessionController.findRunningSession(
                profile.id
            );
            if (!session) {
                return null;
            }

            return await SessionDTOMap(session);
        },
        {
            requireProfile: true,
            detail: {
                description:
                    "Get your current session. Returns `null` if you are not running a session.",
            },
        }
    )
    .post(
        "/",
        async ({ body, profile }) => {
            const session = await lpsessionController.createSession(
                profile.id,
                body.latitude,
                body.longitude,
                body.name,
                body.open ? "OPEN" : "CLOSED"
            );

            if (session === null) {
                throw new ApiError(ErrorTemplates.SESSION_ALREADY_OPEN);
            }

            return await SessionDTOMap(session);
        },
        {
            requireProfile: true,
            body: "sessionParams",
            detail: {
                description: "Create a Session.",
            },
        }
    )
    .get(
        "/:id",
        async ({ params: { id } }) => {
            const session = await lpsessionController.getSession(id);
            if (session === null) {
                throw new ApiError(ErrorTemplates.SESSION_NOT_FOUND);
            }

            return await SessionDTOMap(session);
        },
        {
            requireProfile: true,
            params: t.Object({
                id: t.Number(),
            }),
            detail: {
                description: "Get a session by it's ID.",
            },
        }
    )
    .post(
        "/:id/join",
        async ({ params: { id }, profile }) => {
            const request = await lpsessionController.joinSession(id, profile);
            return request;
        },
        {
            requireProfile: true,
            params: t.Object({
                id: t.Number(),
            }),
            detail: {
                description:
                    "Join a Session. If it's an open session you are automatically in, otherwise you send a request to join.",
            },
        }
    )
    .get(
        "requests/incoming",
        async ({ profile }) => {
            const requests = await lpsessionController.getIncomingRequests(
                profile.id
            );

            const dtos = await Promise.all(
                requests.map(async (r) => ({
                    createdAt: r.createdAt,
                    status: r.status,
                    participantId: r.participantId,
                    sessionId: r.sessionId,
                    participant: await ProfileDTOMap(r.participant),
                }))
            );

            return dtos;
        },
        {
            requireProfile: true,
            detail: {
                description: "Get all incoming requests to join your sessions.",
            },
        }
    )
    .get(
        "requests/sent",
        async ({ profile }) => {
            const requests = await lpsessionController.getSentRequests(
                profile.id
            );

            return requests.map((r) => ({
                createdAt: r.createdAt,
                status: r.status,
                participantId: r.participantId,
                sessionId: r.sessionId,
            }));
        },
        {
            requireProfile: true,
            detail: {
                description: "Get all join requests that you have sent.",
            },
        }
    )
    .post(
        "requests/respond",
        async ({ profile, body: { participantId, sessionId, accept } }) => {
            const session = await lpsessionController.getSession(sessionId);

            if (!session) {
                log.http(`could not find session with id ${sessionId}`);
                throw new ApiError(ErrorTemplates.SESSION_NOT_FOUND);
            }

            if (session.creatorId !== profile.id) {
                throw new AuthenticationError(ErrorTemplates.INVALID_PROFILE);
            }

            const request = await lpsessionController.respondRequest(
                participantId,
                sessionId,
                accept,
                profile
            );

            return request;
        },
        {
            requireProfile: true,
            body: t.Object({
                participantId: t.Number(),
                sessionId: t.Number(),
                accept: t.Boolean(),
            }),
            detail: {
                description: "Send a response to a join request.",
            },
        }
    )
    .post(
        "/close/:id",
        async ({ params: { id }, profile }) => {
            const session = await lpsessionController.getSession(id);

            if (!session) {
                log.http(`could not find session with id ${id}`);
                throw new ApiError(ErrorTemplates.SESSION_NOT_FOUND);
            }

            if (session.creatorId !== profile.id) {
                throw new AuthenticationError(ErrorTemplates.INVALID_PROFILE);
            }

            return await lpsessionController.closeSession(session.id);
        },
        {
            requireProfile: true,
            params: t.Object({
                id: t.Number(),
            }),
            detail: {
                description:
                    "Conclude/Close a session and prevent anyone else from joining.",
            },
        }
    );
