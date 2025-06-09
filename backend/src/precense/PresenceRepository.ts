import { Decimal } from "@prisma/client/runtime/client";
import { prisma } from "../database.ts";
import { MapPresence, Profile } from "../generated/prisma/client.ts";

export type CDecimal = Decimal;

export class PresenceRepository {
    async getPresence(id: number): Promise<MapPresence | null> {
        return await prisma.mapPresence.findUnique({ where: { id: id } });
    }

    decimal(value: string): CDecimal {
        return new Decimal(value);
    }

    async createPresence(
        latitude: CDecimal,
        longitude: CDecimal
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
        latitude: CDecimal,
        longitude: CDecimal
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
        latitude: CDecimal,
        longitude: CDecimal
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
        latitude: CDecimal,
        longitude: CDecimal,
        radius: CDecimal
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
                profile.presence.latitude,
                profile.presence.longitude
            );


            return distance.lessThan(radius);
        });

        return profilesInArea.map(({ presence, ...profile }) => {
            return {
                ...profile,
                persence: presence,
            };
        });
    }

    private calculateDistance(
        lat1: Decimal,
        lon1: Decimal,
        lat2: Decimal,
        lon2: Decimal
    ): Decimal {
        const R = new Decimal(6371); // earth's radius in km
        const PI = new Decimal(Math.PI);
        const deg180 = new Decimal(180);

        const dLat = new Decimal(lat2).minus(lat1).mul(PI).div(deg180);
        const dLon = new Decimal(lon2).minus(lon1).mul(PI).div(deg180);

        const lat1Rad = new Decimal(lat1).mul(PI).div(deg180);
        const lat2Rad = new Decimal(lat2).mul(PI).div(deg180);

        const sinDLatHalf = Decimal.sin(dLat.div(2));
        const sinDLonHalf = Decimal.sin(dLon.div(2));

        const a = sinDLatHalf
            .pow(2)
            .plus(
                Decimal.cos(lat1Rad)
                    .mul(Decimal.cos(lat2Rad))
                    .mul(sinDLonHalf.pow(2))
            );

        const sqrtA = Decimal.sqrt(a);
        const sqrt1MinusA = Decimal.sqrt(new Decimal(1).minus(a));
        const c = new Decimal(2).mul(Decimal.atan2(sqrtA, sqrt1MinusA));

        const distance = R.mul(c);
        return distance;
    }
}
