import { prisma } from "../database.ts";
import { MapPresence, Profile } from "../generated/prisma/client.ts";

export class ProfileRepository {
    async getProfileByOwner(
        index: number,
        ownerId: number
    ): Promise<Profile | null> {
        return await prisma.profile.findUnique({
            where: {
                ownerId_profileOwnerIndex: {
                    ownerId,
                    profileOwnerIndex: index,
                },
            },
        });
    }

    async getPublicProfile(id: number): Promise<Profile & {presence: MapPresence | null} | null> {
        const result = await prisma.profile.findUnique({
            where: {
                id,
            },
            include: {
                presence: true,
            },
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
