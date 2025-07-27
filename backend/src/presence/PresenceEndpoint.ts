import { Elysia, t } from "elysia";
import presenceController from "./presence.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { Decimal } from "@prisma/client/runtime/client";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { SessionDTOMapWithoutParticipantsAndCreator } from "../session/SessionEndpoint.ts";
import { ApiError, ErrorTemplates, UnknownError } from "../errors.ts";

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
                throw new ApiError(ErrorTemplates.PRESENCE_NOT_FOUND);
            }

            const presence = await presenceController.getPresence(
                profile.realPresenceId,
                profile.fakePresenceId
            );

            return PresenceDTOMapWithPrivate(presence);
        },
        {
            requireProfile: true,
            detail: {
                description: "Get your current location.",
            },
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
                throw new UnknownError("Failed to set presence.")
            }

            return PresenceDTOMapWithPrivate(presence);
        },
        {
            requireProfile: true,
            body: "presenceLocation",
            detail: {
                description:
                    "Change your current location. This will return both real and fake location, a user can send this endpoint multiple times to choose their fake location.",
            },
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
                throw new UnknownError("Unable to delete current presence.");
            }
        },
        {
            requireProfile: true,
            detail: {
                description: "Delete your current location.",
            },
        }
    )
    .get(
        "/nearby",
        async ({ query, user, profile }) => {
            const { latitude, longitude, radiusKm = "10" } = query;

            log.http(
                `Get nearby profiles request from user ${user.username} at (${latitude}, ${longitude}) within ${radiusKm}km`
            );

            const profiles = await presenceController.getProfilesInArea(
                profile.id,
                latitude,
                longitude,
                radiusKm
            );

            log.info(`Got ${profiles.length} profiles from nearby search`);

            const profilesDTO = await Promise.all(
                profiles.map(async (p) => {
                    const dto = await ProfileDTOMap(p);
                    const session = p.sessionsMade[0] ?? null;
                    return {
                        ...dto,
                        session: session
                            ? SessionDTOMapWithoutParticipantsAndCreator(
                                  session
                              )
                            : null,
                    };
                })
            );

            return { profiles: profilesDTO };
        },
        {
            requireProfile: true,
            query: "areaQuery",
            detail: {
                description:
                    "List all nearby Profiles in a radius. If a Profile is hosting a session it can be foudn in `session` otherwise `null`.",
            },
        }
    );
