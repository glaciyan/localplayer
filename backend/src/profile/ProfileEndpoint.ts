import { Elysia, status, t } from "elysia";
import profileController from "./profile.ts";
import { mklog } from "../logger.ts";
import { AuthService } from "../authentication/AuthService.ts";
import { SwipeType } from "../generated/prisma/enums.ts";
import { spotify } from "../spotify/SpotifyEndpoint.ts";
import lpsessionController from "../session/session.ts";

const log = mklog("profile-api");

function getColorForSessionStatus(status: string) {
    log.info(status);
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

    try {
        const session = await lpsessionController.findRunningSession(p.id);
        if (session) {
            color = getColorForSessionStatus(session.status);
        }
    } catch (e) {
        log.error(
            "could not get currenct session for user, using default color"
        );
    }

    let avatarLink = null;
    let backgroundLink = null;

    if (p.spotifyId) {
        try {
            const image = await fetchSpotifyUserAvatar(p.spotifyId);
            avatarLink = image;
            backgroundLink = image;
        } catch (e) {
            log.error("failed to get profile image for spotify account");
        }
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
        avatarLink: avatarLink,
        backgroundLink: backgroundLink,
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

interface SpotifyImage {
    url: string;
    height: number | null;
    width: number | null;
}

interface SpotifyUserProfile {
    id: string;
    display_name: string;
    images: SpotifyImage[];
}

export async function fetchSpotifyUserAvatar(
    userId: string
): Promise<string | null> {
    const response = await fetch(
        `https://api.spotify.com/v1/artists/${encodeURIComponent(userId)}`,
        {
            headers: {
                Authorization: `Bearer ${await spotify.getAccessToken()}`,
                "Content-Type": "application/json",
            },
        }
    );

    if (!response.ok) {
        log.error(
            `Spotify API error: ${response.status} ${response.statusText}`
        );
        return null;
    }

    const profile: SpotifyUserProfile = await response.json();
    // Return the first image's URL, if available
    return profile.images.length > 0 ? profile.images[0]!.url : null;
}

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
            if (prof.spotifyId) {
                try {
                    const image = await fetchSpotifyUserAvatar(prof.spotifyId);
                    return await FullProfileDTOMap({
                        ...prof,
                        avatarLink: image,
                        backgroundLink: image,
                    });
                } catch {
                    log.error(
                        "could not fetch spotify images for id " +
                            prof.spotifyId
                    );
                }
            }

            return await FullProfileDTOMap({
                ...prof,
                avatarLink: null,
                backgroundLink: null,
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
                return status(400, "Invalid profile ID");
            }

            log.http(
                `Get public profile request from user ${user.username} for profile ${profileId}`
            );

            const profile = await profileController.getPublicProfile(profileId);
            if (profile === null) {
                return status(404, "Profile Not Found");
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

            if (updatedProfile === null) {
                return status(500, "Failed to update profile");
            }

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
