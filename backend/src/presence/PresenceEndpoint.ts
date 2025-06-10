import { Elysia, status, t } from "elysia";
import presenceController from "./presence.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { Decimal } from "@prisma/client/runtime/client";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { SessionDTOMap, SessionDTOMapWithoutParticipants } from "../session/SessionEndpoint.ts";

const log = mklog("presence-api");

type Presence = {
    realPresence: {
        id: number;
        latitude: Decimal;
        longitude: Decimal;
    } | null;
    fakePresence: {
        id: number;
        latitude: Decimal;
        longitude: Decimal;
    } | null;
};

export const PresenceDTOMapWithPrivate = (p: Presence) => ({
    real: {
        latitude: p?.realPresence?.latitude,
        longitude: p?.realPresence?.longitude,
    },
    fake: {
        latitude: p?.fakePresence?.latitude,
        longitude: p?.fakePresence?.longitude,
    },
});

export const PresenceDTOMap = (p: Presence) => ({
    precense: {
        latitude: p?.fakePresence?.latitude,
        longitude: p?.fakePresence?.longitude,
    },
});

export const PresenceEndpoint = new Elysia({ prefix: "/presence" })
    .use(AuthService)
    .model({
        presenceLocation: t.Object({
            latitude: t.String(),
            longitude: t.String(),
            fakingRadiusMeters: t.String(),
        }),
        areaQuery: t.Object({
            latitude: t.String(),
            longitude: t.String(),
            radiusKm: t.Optional(t.String()),
        }),
    })
    .get(
        "/current",
        async ({ user, profile }) => {
            log.http(
                `Get current presence request from user ${user.username} for profile ${profile.id}`
            );

            if (!profile.realPresenceId) {
                return status(404, "No presence set for this profile");
            }

            const presence = await presenceController.getPresence(
                profile.realPresenceId,
                profile.fakePresenceId
            );

            return PresenceDTOMapWithPrivate(presence);
        },
        {
            cookie: "session",
            requireProfile: true,
        }
    )
    .post(
        "/current",
        async ({ body, user, profile }) => {
            log.http(
                `Set presence request from user ${user.username} for profile ${profile.id}`
            );

            const presence = await presenceController.setProfilePresence(
                profile.id,
                body.latitude,
                body.longitude,
                body.fakingRadiusMeters
            );

            if (!presence) {
                return status(500, "Failed to set presence");
            }

            return PresenceDTOMapWithPrivate(presence);
        },
        {
            cookie: "session",
            requireProfile: true,
            body: "presenceLocation",
        }
    )
    .delete(
        "/current",
        async ({ user, profile }) => {
            log.http(
                `Remove presence request from user ${user.username} for profile ${profile.id}`
            );

            const success = await presenceController.removeProfilePresence(
                profile.id
            );

            if (!success) {
                return status(500, "Failed to remove presence");
            }

            return status(200);
        },
        {
            cookie: "session",
            requireProfile: true,
        }
    )
    .get(
        "/nearby",
        async ({ query, user }) => {
            const { latitude, longitude, radiusKm = "10" } = query;

            log.http(
                `Get nearby profiles request from user ${user.username} at (${latitude}, ${longitude}) within ${radiusKm}km`
            );

            const profiles = await presenceController.getProfilesInArea(
                latitude,
                longitude,
                radiusKm
            );

            const sessions = await presenceController.getSessionsInArea(
                latitude,
                longitude,
                radiusKm
            );

            return {
                profiles: profiles.map((p) => ProfileDTOMap(p)),
                sessions: sessions.map((s) => SessionDTOMapWithoutParticipants(s)),
            };
        },
        {
            cookie: "session",
            requireSession: true,
            query: "areaQuery",
        }
    );
