import { CustomValidationError } from "../errors.ts";
import profileController from "../profile/profile.ts";
import { CDecimal, PresenceRepository } from "./PresenceRepository.ts";

export class PresenceService {
    handler: PresenceRepository;

    constructor(handler: PresenceRepository) {
        this.handler = handler;
    }

    public validateCoords(lat: CDecimal, lng: CDecimal) {
        const fieldErrors: Record<string, string> = {};

        if (lat.lessThan(-90) || lat.greaterThan(90)) {
            fieldErrors["latitude"] = "Latitude is out of range";
        }

        if (lng.lessThan(-180) || lng.greaterThan(180)) {
            fieldErrors["longitude"] = "Longitude is out of range";
        }

        if (Object.keys(fieldErrors).length > 0) {
            throw new CustomValidationError(fieldErrors);
        }
    }

    public convertCoords(latitude: string, longitude: string) {
        const lat = this.handler.decimal(latitude);
        const lng = this.handler.decimal(longitude);
        this.validateCoords(lat, lng);
        return { lat, lng };
    }

    async getPresence(realPresenceId: number, fakePresenceId: number | null) {
        return await this.handler.getPresence(realPresenceId, fakePresenceId);
    }

    async updatePresence(
        id: number,
        fakeId: number | null,
        latitude: string,
        longitude: string,
        radiusMeters: string
    ) {
        const { lat, lng } = this.convertCoords(latitude, longitude);

        return await this.handler.updatePresence(
            id,
            fakeId,
            lat,
            lng,
            this.handler.decimal(radiusMeters)
        );
    }

    async deletePresence(id: number, fakePresenceId: number | null) {
        return await this.handler.deletePresence(id, fakePresenceId);
    }

    async setProfilePresence(
        profileId: number,
        latitude: string,
        longitude: string,
        fakingRadiusMeters: string
    ) {
        // Get current profile to check if it has a presence
        const profile = await profileController.getPublicProfile(profileId);
        if (!profile) {
            return null;
        }

        const { lat, lng } = this.convertCoords(latitude, longitude);

        if (profile.realPresenceId) {
            return await this.updatePresence(
                profile.realPresenceId,
                profile.fakePresenceId,
                latitude,
                longitude,
                fakingRadiusMeters
            );
        } else {
            return await this.handler.createPresenceForProfile(
                profileId,
                lat,
                lng,
                this.handler.decimal(fakingRadiusMeters)
            );
        }
    }

    async removeProfilePresence(profileId: number) {
        const profile = await profileController.getPublicProfile(profileId);
        if (!profile || !profile.realPresenceId) {
            return false;
        }

        return await this.deletePresence(
            profile.realPresenceId,
            profile.fakePresenceId
        );
    }

    async getProfilesInArea(
        excludeProfile: number,
        latitude: string,
        longitude: string,
        radiusKm: string
    ) {
        const { lat, lng } = this.convertCoords(latitude, longitude);

        const rad = this.handler.decimal(radiusKm);

        const profiles = await this.handler.getProfilesInArea(excludeProfile, lat, lng, rad);

        return profiles;
    }

    async getSessionsInArea(
        latitude: string,
        longitude: string,
        radiusKm: string
    ) {
        const { lat, lng } = this.convertCoords(latitude, longitude);

        const rad = this.handler.decimal(radiusKm);

        const profiles = await this.handler.getSessionsInArea(lat, lng, rad);

        return profiles;
    }
}
