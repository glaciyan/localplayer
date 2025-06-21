import { Decimal } from "@prisma/client/runtime/client";
import { prisma } from "../database.ts";
import { mklog } from "../logger.ts";
import { PublicProfileIncludes } from "../profile/ProfileRepository.ts";
import { SessionIncludes } from "../session/LPSessionService.ts";

const log = mklog("presence-repo");

export type CDecimal = Decimal;

export class PresenceRepository {
    async getPresence(realPresenceId: number, fakePresenceId: number | null) {
        const realPresence = await prisma.mapPresence.findUnique({
            where: { id: realPresenceId },
        });
        if (realPresence === null) {
            throw "Constraint Error: Real Coordinate was not found";
        }

        if (fakePresenceId) {
            const fakePresence = await prisma.mapPresence.findUnique({
                where: { id: fakePresenceId },
            });
            return { realPresence, fakePresence };
        }
        return { realPresence, fakePresence: null };
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
                realPresence: {
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
                realPresence: true,
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
            const realPresence = await prisma.mapPresence.update({
                where: { id: id },
                data: {
                    latitude: latitude,
                    longitude: longitude,
                },
            });

            if (fakeId !== null) {
                const fakePresence = await prisma.mapPresence.update({
                    where: { id: fakeId },
                    data: this.addNoiseToCoordinates(
                        latitude,
                        longitude,
                        noiseRadiusMeters
                    ),
                });

                return { realPresence, fakePresence };
            }

            return { realPresence, fakePresence: null };
        } catch (error) {
            return null;
        }
    }

    async deletePresence(
        id: number,
        fakePresenceId: number | null
    ): Promise<boolean> {
        try {
            await prisma.mapPresence.delete({
                where: { id: id },
            });

            if (fakePresenceId) {
                await prisma.mapPresence.delete({
                    where: { id: fakePresenceId },
                });
            }
            return true;
        } catch (error) {
            return false;
        }
    }

    async getProfilesInArea(
        excludeProfile: number,
        latitude: CDecimal,
        longitude: CDecimal,
        radiusKm: CDecimal
    ) {
        const profilesWithPresence = await prisma.profile.findMany({
            where: {
                realPresenceId: {
                    not: null,
                },
                id: {
                    not: excludeProfile,
                },
            },
            include: {
                ...PublicProfileIncludes,
                sessionsMade: {
                    where: {
                        status: {
                            not: "CONCLUDED",
                        },
                    },
                    include: SessionIncludes,
                },
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

    async getSessionsInArea(
        latitude: CDecimal,
        longitude: CDecimal,
        radiusKm: CDecimal
    ) {
        const activeSessions = await prisma.lPSession.findMany({
            where: {
                status: {
                    not: "CONCLUDED",
                },
            },
            include: {
                presence: true,
                creator: {
                    include: PublicProfileIncludes,
                },
            },
        });

        const sessionsInArea = activeSessions.filter((session) => {
            const distance = this.calculateDistance(
                latitude,
                longitude,
                session.presence.latitude,
                session.presence.longitude
            );

            return distance.lessThan(radiusKm);
        });

        return sessionsInArea;
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
