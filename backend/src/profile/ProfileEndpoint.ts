import { Elysia, status, t } from "elysia";
import profileController from "./profile.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";

const log = mklog("profile-api");

export const ProfileDTOMap = (p: any) => ({
    id: p.id,
    createdAt: p.createdAt,
    handle: p.handle,
    displayName: p.displayName,
    biography: p.biography,
    likes: p._count.swipesReceived,
    presence: p.fakePresence
        ? {
              latitude: p.fakePresence?.latitude,
              longitude: p.fakePresence?.longitude,
          }
        : null,
});

export const ProfileEndpoint = new Elysia({ prefix: "/profile" })
    .use(AuthService)
    .get(
        "/my-profiles",
        async ({ user }) => {
            log.http(`Get user profiles request from user ${user.username}`);
            const profiles = await profileController.getMyProfiles(user.id);
            return profiles;
        },
        {
            cookie: "session",
            requireSession: true,
            detail: {
                description:
                    "Get all your registered profiles, in case multi-profiles are used.",
            },
        }
    )
    .get(
        "/me",
        async ({ user, profile }) => {
            log.http(
                `Get current profile request from user ${user.username} for profile [${profile.profileOwnerIndex}] ${profile.handle}`
            );
            return profile;
        },
        {
            cookie: "session",
            requireProfile: true,
            detail: {
                description: "Get your current profile.",
            },
        }
    )
    .get(
        "/:id",
        async ({ params: { id }, user }) => {
            const profileId = parseInt(id);
            if (isNaN(profileId)) {
                return status(400, "Invalid profile ID");
            }

            log.http(
                `Get public profile request from user ${user.username} for profile ${profileId}`
            );

            const profile = await profileController.getPublicProfile(profileId);
            if (profile === null) {
                return status(404, "Profile Not Found");
            }

            log.info(JSON.stringify(profile))

            return ProfileDTOMap(profile);
        },
        {
            cookie: "session",
            requireSession: true,
            detail: {
                description: "Get info about a public profile.",
            },
        }
    )
    .patch(
        "/me",
        async ({ body, user, profile }) => {
            log.http(
                `Update profile request from user ${user.username} for profile ${profile.id}`
            );

            const updatedProfile = await profileController.updateProfile(
                profile.id,
                body.displayName,
                body.biography
            );

            if (updatedProfile === null) {
                return status(500, "Failed to update profile");
            }

            return updatedProfile;
        },
        {
            cookie: "session",
            requireProfile: true,
            body: t.Object({
                displayName: t.Optional(t.String()),
                biography: t.Optional(t.String()),
            }),
            detail: {
                description: "Edit your current profile.",
            },
        }
    );
