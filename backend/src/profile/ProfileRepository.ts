import { prisma } from "../database.ts";
import { Profile } from "../generated/prisma/client.ts";
import { mklog } from "../logger.ts";
import { spotify } from "./spotify.ts";

const log = mklog("profile-repo");

export const PublicProfileIncludes = {
    fakePresence: true,
    realPresence: true,
    swipesReceived: true,
} as const;

export const PublicProfileIncludesWithoutLikeCount = {
    fakePresence: true,
    realPresence: true,
} as const;

interface SpotifyImage {
    url: string;
    height: number | null;
    width: number | null;
}

interface SpotifyUserProfile {
    id: string;
    display_name: string;
    images: SpotifyImage[];
    popularity: number;
    followers: {
        href: string;
        total: number;
    };
}

export async function fetchSpotifyUserData(userId: string) {
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
            `Spotify API error: ${response.status} ${response.statusText} ${userId}`
        );
        return null;
    }

    const profile: SpotifyUserProfile = await response.json();
    // Return the first image's URL, if available
    return {
        image: profile.images.length > 0 ? profile.images[0]!.url : null,
        popularity: profile.popularity,
        followers: profile.followers.total,
    };
}

export class ProfileRepository {
    async getProfileByOwner(index: number, ownerId: number) {
        return await prisma.profile.findUnique({
            where: {
                ownerId_profileOwnerIndex: {
                    ownerId,
                    profileOwnerIndex: index,
                },
            },
            include: PublicProfileIncludes,
        });
    }

    async getPublicProfile(id: number) {
        const result = await prisma.profile.findUnique({
            where: {
                id,
            },
            include: PublicProfileIncludes,
        });

        return result;
    }

    async getMyProfiles(userId: number): Promise<Profile[]> {
        return await prisma.profile.findMany({
            where: { ownerId: userId },
        });
    }

    getSpotifyArtistId(input: string): string | null {
        // If input is just the artist ID (alphanumeric), return it directly
        if (/^[A-Za-z0-9]+$/.test(input)) {
            return input;
        }

        try {
            // Look for "artist/<id>" anywhere in the string
            const regex = /artist\/([A-Za-z0-9]+)/;
            const match = input.match(regex);
            return match?.[1] ?? null;
        } catch {
            return null;
        }
    }

    async updateProfile(
        id: number,
        displayName?: string,
        biography?: string,
        spotifyLink?: string
    ): Promise<Profile | null> {
        const updateData: {
            displayName?: string;
            biography?: string;
            spotifyId?: string;
            avatarLink?: string;
            backgroundLink?: string;
            followers?: number;
            popularity?: number;
        } = {};

        if (displayName !== undefined) {
            updateData.displayName = displayName;
        }

        if (biography !== undefined) {
            updateData.biography = biography;
        }

        if (spotifyLink !== undefined) {
            const spotifyId = this.getSpotifyArtistId(spotifyLink);
            if (!spotifyId) {
                log.error(`No artist id found in link ${spotifyLink}`);
                return null;
            }

            const profile = await fetchSpotifyUserData(spotifyId);
            if (profile && profile.image) {
                updateData.avatarLink = profile.image;
                updateData.backgroundLink = profile.image;
                updateData.followers = profile.followers;
                updateData.popularity = profile.popularity;
            }

            log.info(`Got valid id ${spotifyId}`);
            updateData.spotifyId = spotifyId;
        }

        if (Object.keys(updateData).length === 0) {
            return await this.getPublicProfile(id);
        }

        return await prisma.profile.update({
            where: { id: id },
            data: updateData,
            include: PublicProfileIncludes
        });
    }
}
