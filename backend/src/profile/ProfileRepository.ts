import { prisma } from "../database.ts";
import { Profile } from "../generated/prisma/client.ts";

export class ProfileRepository {
    async getProfileByOwner(index: number, ownerId: number) {
        return await prisma.profile.findUnique({
            where: {
                ownerId_profileOwnerIndex: {
                    ownerId,
                    profileOwnerIndex: index,
                },
            },
            include: {
                fakePresence: { omit: { id: true } },
                presence: { omit: { id: true } },
            },
        });
    }

    async getPublicProfile(id: number) {
        const result = await prisma.profile.findUnique({
            where: {
                id,
            },
            include: {
                fakePresence: { omit: { id: true } },
                presence: { omit: { id: true } },
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
