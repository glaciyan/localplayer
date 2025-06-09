import { Decimal } from "@prisma/client/runtime/client";
import { prisma } from "../database.ts";
import { MapPresence } from "../generated/prisma/client.ts";
import { mklog } from "../logger.ts";

const log = mklog("presence-repo");

export type CDecimal = Decimal;

export class PresenceRepository {
    async getPresence(id: number): Promise<MapPresence | null> {
        return await prisma.mapPresence.findUnique({ where: { id: id } });
    }

    decimal(value: string): CDecimal {
        return new Decimal(value);
    }

    private addNoiseToCoordinates(
        latitude: CDecimal,
        longitude: CDecimal,
        noiseRadiusMeters: CDecimal
    ): { latitude: CDecimal; longitude: CDecimal } {
        const earthRadiusKm = new Decimal(6371);
        const noiseRadiusKm = noiseRadiusMeters.div(1000);

        const randomAngle = new Decimal(Math.random()).mul(2).mul(Math.PI);
        const randomDistance = new Decimal(Math.random()).mul(noiseRadiusKm);

        const latNoise = randomDistance
            .mul(Decimal.cos(randomAngle))
            .div(earthRadiusKm)
            .mul(180)
            .div(Math.PI);

        const lonNoise = randomDistance
            .mul(Decimal.sin(randomAngle))
            .div(earthRadiusKm)
            .mul(180)
            .div(Math.PI)
            .div(Decimal.cos(latitude.mul(Math.PI).div(180)));

        return {
            latitude: latitude.add(latNoise),
            longitude: longitude.add(lonNoise),
        };
    }

    async createPresenceForProfile(
        profileId: number,
        latitude: CDecimal,
        longitude: CDecimal,
        noiseRadiusMeters: CDecimal
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
                fakePresence: {
                    create: this.addNoiseToCoordinates(
                        latitude,
                        longitude,
                        noiseRadiusMeters
                    ),
                },
            },
            include: {
                presence: true,
                fakePresence: true,
            },
        });

        return result;
    }

    async updatePresence(
        id: number,
        fakeId: number | null,
        latitude: CDecimal,
        longitude: CDecimal,
        noiseRadiusMeters: CDecimal
    ) {
        try {
            const real = await prisma.mapPresence.update({
                where: { id: id },
                data: {
                    latitude: latitude,
                    longitude: longitude,
                },
            });

            if (fakeId !== null) {
                const fake = await prisma.mapPresence.update({
                    where: { id: fakeId },
                    data: this.addNoiseToCoordinates(
                        latitude,
                        longitude,
                        noiseRadiusMeters
                    ),
                });

                return { real, fake };
            }

            return { real };
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
        radiusKm: CDecimal
    ) {
        const profilesWithPresence = await prisma.profile.findMany({
            where: {
                presenceId: {
                    not: null,
                },
            },
            include: {
                fakePresence: true,
            },
        });

        const profilesInArea = profilesWithPresence.filter((profile) => {
            if (!profile.fakePresence) return false;

            const distance = this.calculateDistance(
                latitude,
                longitude,
                profile.fakePresence.latitude,
                profile.fakePresence.longitude
            );

            log.info(distance.toString());

            return distance.lessThan(radiusKm);
        });

        return profilesInArea;
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
