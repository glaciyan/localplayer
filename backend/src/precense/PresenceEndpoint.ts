import { Elysia, status, t } from "elysia";
import presenceController from "./presence.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";

const log = mklog("presence-api");

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

            if (!profile.presenceId) {
                return status(404, "No presence set for this profile");
            }

            const presence = await presenceController.getPresence(
                profile.presenceId
            );
            if (!presence) {
                return status(404, "Presence not found");
            }

            return {
                latitude: presence.latitude,
                longitude: presence.longitude,
            };
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

            return presence;
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

            return profiles;
        },
        {
            cookie: "session",
            requireSession: true,
            query: "areaQuery",
        }
    );
