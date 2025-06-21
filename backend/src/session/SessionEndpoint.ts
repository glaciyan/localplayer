import { Elysia, status, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import lpsessionController from "./session.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { UNAUTHORIZED } from "../errors.ts";
import { mklog } from "../logger.ts";

const log = mklog("lpsession");

export const SessionDTOMap = (session: any) => ({
    ...SessionDTOMapWithoutParticipants(session),
    participations: session.participants.map((p: any) => ({
        status: p.status,
        participant: ProfileDTOMap(p.participant),
    })),
});

export const SessionDTOMapWithoutParticipants = (session: any) => ({
    ...SessionDTOMapWithoutParticipantsAndCreator(session),
    creator: ProfileDTOMap(session.creator),
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
                return status(404, "null");
            }

            return SessionDTOMap(session);
        },
        {
            cookie: "session",
            requireProfile: true,
            detail: {
                description:
                    "Get your current session. Returns 404 and `null` if you are not running a session.",
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
                return status(403, "You already have an open session");
            }

            return SessionDTOMap(session);
        },
        {
            cookie: "session",
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
                return status(404);
            }

            return SessionDTOMap(session);
        },
        {
            cookie: "session",
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
            cookie: "session",
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

            return requests.map((r) => ({
                createdAt: r.createdAt,
                status: r.status,
                participantId: r.participantId,
                sessionId: r.sessionId,
                participant: ProfileDTOMap(r.participant),
            }));
        },
        {
            cookie: "session",
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
            cookie: "session",
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
                return status(404);
            }

            if (session.creatorId !== profile.id) {
                return status(403, UNAUTHORIZED);
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
            cookie: "session",
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
                return status(404);
            }

            if (session.creatorId !== profile.id) {
                return status(403, UNAUTHORIZED);
            }

            return await lpsessionController.closeSession(session.id);
        },
        {
            cookie: "session",
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
