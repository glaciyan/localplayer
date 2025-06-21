import { prisma } from "../database.ts";
import { Profile } from "../generated/prisma/client.ts";

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

    async updateProfile(
        id: number,
        displayName?: string,
        biography?: string
    ): Promise<Profile | null> {
        const updateData: { displayName?: string; biography?: string } = {};

        if (displayName !== undefined) {
            updateData.displayName = displayName;
        }

        if (biography !== undefined) {
            updateData.biography = biography;
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
