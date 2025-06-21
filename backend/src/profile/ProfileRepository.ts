import { prisma } from "../database.ts";
import { Profile } from "../generated/prisma/client.ts";
import { mklog } from "../logger.ts";

const log = mklog("profile-repo");

export const PublicProfileIncludes = {
    fakePresence: true,
    realPresence: true,
    _count: {
        select: {
            swipesReceived: {
                where: {
                    type: "POSITIVE",
                },
            },
        },
    },
} as const;

export const PublicProfileIncludesWithoutLikeCount = {
    fakePresence: true,
    realPresence: true,
} as const;

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

    getSpotifyArtistId(url: string): string | null {
        try {
            const regex = /spotify\.com\/artist\/([a-zA-Z0-9]+)/;
            const match = url.match(regex);
            if (match && match[1]) {
                return match[1];
            } else {
                return null;
            }
        } catch (error) {
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
        } = {};

        if (displayName !== undefined) {
            updateData.displayName = displayName;
        }

        if (biography !== undefined) {
            updateData.biography = biography;
        }

        if (spotifyLink !== undefined) {
            const spotifyId = this.getSpotifyArtistId(spotifyLink);
            if (spotifyId) {
                log.info(`Got valid id ${spotifyId}`)
                updateData.spotifyId = spotifyId;
            } else {
                log.error(`No artist id found in link ${spotifyLink}`);
                return null;
            }
        }

        if (Object.keys(updateData).length === 0) {
            return await this.getPublicProfile(id);
        }

        return await prisma.profile.update({
            where: { id: id },
            data: updateData,
        });
    }
}
