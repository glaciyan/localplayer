import { IPresenceHandler } from "./IPresenceHandler.ts";
import { prisma } from "../database.ts";
import { MapPresence, Profile } from "../generated/prisma/client.ts";

export class PresenceRepository implements IPresenceHandler {
    async getPresence(id: number): Promise<MapPresence | null> {
        return await prisma.mapPresence.findUnique({ where: { id: id } });
    }

    async createPresence(
        latitude: number,
        longitude: number
    ): Promise<MapPresence> {
        return await prisma.mapPresence.create({
            data: {
                latitude: latitude,
                longitude: longitude,
            },
        });
    }

    async createPresenceForProfile(
        profileId: number,
        latitude: number,
        longitude: number
    ) {
        const result = await prisma.profile.update({
            where: {
                id: profileId,
            },
            data: {
                presence: {
                    create: {
                        latitude: latitude,
                        longitude: longitude,
                    },
                },
            },
            include: {
                presence: true,
            },
        });

        return result.presence;
    }

    async updatePresence(
        id: number,
        latitude: number,
        longitude: number
    ): Promise<MapPresence | null> {
        try {
            return await prisma.mapPresence.update({
                where: { id: id },
                data: {
                    latitude: latitude,
                    longitude: longitude,
                },
            });
        } catch (error) {
            return null;
        }
    }

    async deletePresence(id: number): Promise<boolean> {
        try {
            await prisma.mapPresence.delete({
                where: { id: id },
            });
            return true;
        } catch (error) {
            return false;
        }
    }

    async getProfilesInArea(
        latitude: number,
        longitude: number,
        radius: number
    ): Promise<Profile[]> {
        const profilesWithPresence = await prisma.profile.findMany({
            where: {
                presenceId: {
                    not: null,
                },
            },
            include: {
                presence: true,
            },
        });

        const profilesInArea = profilesWithPresence.filter((profile) => {
            if (!profile.presence) return false;

            const distance = this.calculateDistance(
                latitude,
                longitude,
                parseFloat(profile.presence.latitude.toString()),
                parseFloat(profile.presence.longitude.toString())
            );

            return distance <= radius;
        });

        // Remove the presence data before returning (keep only profile data)
        return profilesInArea.map(({ presence, ...profile }) => profile);
    }

    private calculateDistance(
        lat1: number,
        lon1: number,
        lat2: number,
        lon2: number
    ): number {
        const R = 6371; // earth's radius in km
        const dLat = ((lat2 - lat1) * Math.PI) / 180;
        const dLon = ((lon2 - lon1) * Math.PI) / 180;

        const a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos((lat1 * Math.PI) / 180) *
                Math.cos((lat2 * Math.PI) / 180) *
                Math.sin(dLon / 2) *
                Math.sin(dLon / 2);

        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        const distance = R * c;

        return distance;
    }
}
