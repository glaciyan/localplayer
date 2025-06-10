import { Elysia, status, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import lpsessionController from "./session.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";

const SessionDTOMap = (session: any) => ({
    id: session.id,
    createdAt: session.createdAt,
    updateAt: session.updateAt,
    status: session.status,
    name: session.name,
    presence: {
        latitude: session.presence.latitude,
        longitude: session.presence.longitude,
    },
    creator: ProfileDTOMap(session.creator),
    participations: session.participants.map((p: any) => ({
        status: p.status,
        participant: ProfileDTOMap(p.participant),
    })),
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

            return SessionDTOMap(session);
        },
        {
            cookie: "session",
            requireProfile: true,
            body: "sessionParams",
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
        }
    )
    .post(
        "/:id/join",
        async ({ params: { id }, profile }) => {
            const request = await lpsessionController.joinSession(
                id,
                profile.id
            );
            return request;
        },
        {
            cookie: "session",
            requireProfile: true,
            params: t.Object({
                id: t.Number(),
            }),
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
        }
    )
    .get(
        "requests/sent",
        async () => {
            //
        },
        {
            cookie: "session",
            requireProfile: true,
        }
    );
