import { Elysia, status, t } from "elysia";
import presenceController from "./presence.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";

const log = mklog("presence-api");

export const PresenceEndpoint = new Elysia({ prefix: "/presence" })
    .use(AuthService)
    .model({
        presenceLocation: t.Object({
            latitude: t.Number({ minimum: -90, maximum: 90 }),
            longitude: t.Number({ minimum: -180, maximum: 180 }),
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

            return presence;
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
                body.longitude
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
            const { latitude, longitude, radius = "10" } = query;

            if (!latitude || !longitude) {
                return status(400, "Latitude and longitude are required");
            }

            const lat = parseFloat(latitude);
            const lng = parseFloat(longitude);
            const rad = parseFloat(radius);

            if (isNaN(lat) || isNaN(lng) || isNaN(rad)) {
                return status(400, "Invalid numeric values");
            }

            if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                return status(400, "Invalid latitude or longitude values");
            }

            if (rad <= 0 || rad > 100) {
                return status(400, "Radius must be between 0 and 100 km");
            }

            log.http(
                `Get nearby profiles request from user ${user.username} at (${lat}, ${lng}) within ${rad}km`
            );

            const profiles = await presenceController.getProfilesInArea(
                lat,
                lng,
                rad
            );
            return profiles;
        },
        {
            cookie: "session",
            requireSession: true,
        }
    );
