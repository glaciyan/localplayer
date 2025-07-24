import { Elysia, t } from "elysia";
import profileController from "./profile.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { SwipeType } from "../generated/prisma/enums.ts";
import lpsessionController from "../session/session.ts";
import { ProfileNotFoundError } from "../errors.ts";

const log = mklog("profile-api");

function getColorForSessionStatus(status: string) {
    switch (status) {
        case "OPEN":
            return "#98D67C";
        case "CLOSED":
            return "#FBB348";
        default:
            return "#C4C4C4";
    }
}

export const ProfileDTOMap = async (p: any) => {
    if (!p) return null;
    let color = "#C4C4C4";
    let sessionStatus = null;

    try {
        const session = await lpsessionController.findRunningSession(p.id);
        if (session) {
            color = getColorForSessionStatus(session.status);
            sessionStatus = session.status;
        }
    } catch (e) {
        log.error(
            "could not get currenct session for user, using default color"
        );
    }

    return {
        color,
        id: p.id,
        createdAt: p.createdAt,
        handle: p.handle,
        displayName: p.displayName ?? p.handle,
        biography: p.biography,
        likes: p.swipesReceived.filter(
            (swipe: { type: SwipeType }) => swipe.type === "POSITIVE"
        ).length,
        dislikes: p.swipesReceived.filter(
            (swipe: { type: SwipeType }) => swipe.type === "NEGATIVE"
        ).length,
        spotifyId: p.spotifyId,
        avatarLink: p.avatarLink,
        backgroundLink: p.backgroundLink,
        followers: p.followers,
        popularity: p.popularity,
        sessionStatus: sessionStatus,
        presence: p.fakePresence
            ? {
                  latitude: p.fakePresence?.latitude,
                  longitude: p.fakePresence?.longitude,
              }
            : null,
    };
};

export const FullProfileDTOMap = async (p: any) => {
    return { ...(await ProfileDTOMap(p)), ...p };
};

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
            const prof = (await profileController.getProfile(
                profile.ownerId,
                profile.profileOwnerIndex
            ))!;
            return await FullProfileDTOMap({
                ...prof
            });
        },
        {
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
                throw new ProfileNotFoundError();
            }

            log.http(
                `Get public profile request from user ${user.username} for profile ${profileId}`
            );

            const profile = await profileController.getPublicProfile(profileId);
            if (profile === null) {
                throw new ProfileNotFoundError();
            }

            log.info(JSON.stringify(profile));

            return await ProfileDTOMap(profile);
        },
        {
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
                body.biography,
                body.spotifyLink
            );

            return updatedProfile;
        },
        {
            requireProfile: true,
            body: t.Object({
                displayName: t.Optional(t.String()),
                biography: t.Optional(t.String()),
                spotifyLink: t.Optional(t.String()),
            }),
            detail: {
                description: "Edit your current profile.",
            },
        }
    );
