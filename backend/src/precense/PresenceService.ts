import profileController from "../profile/profile.ts";
import { CDecimal, PresenceRepository } from "./PresenceRepository.ts";

export class PresenceService {
    handler: PresenceRepository;

    constructor(handler: PresenceRepository) {
        this.handler = handler;
    }

    private validateCoords(lat: CDecimal, lng: CDecimal) {
        if (lat.lessThan(-90) || lat.greaterThan(90)) {
            throw "Invalid latitude";
        }

        if (lng.lessThan(-180) || lat.greaterThan(180)) {
            throw "Invalid longitude";
        }
    }

    async getPresence(id: number) {
        return await this.handler.getPresence(id);
    }

    async updatePresence(id: number, latitude: string, longitude: string) {
        const lat = this.handler.decimal(latitude);
        const lng = this.handler.decimal(longitude);
        this.validateCoords(lat, lng);

        return await this.handler.updatePresence(id, lat, lng);
    }

    async deletePresence(id: number) {
        return await this.handler.deletePresence(id);
    }

    async setProfilePresence(
        profileId: number,
        latitude: string,
        longitude: string
    ) {
        // Get current profile to check if it has a presence
        const profile = await profileController.getFullPublicProfile(profileId);
        if (!profile) {
            return null;
        }

        const lat = this.handler.decimal(latitude);
        const lng = this.handler.decimal(longitude);
        this.validateCoords(lat, lng);

        let presence;
        if (profile.presenceId) {
            presence = await this.updatePresence(
                profile.presenceId,
                latitude,
                longitude
            );
        } else {
            presence = await this.handler.createPresenceForProfile(
                profileId,
                lat,
                lng
            );
        }

        return presence;
    }

    async removeProfilePresence(profileId: number) {
        const profile = await profileController.getFullPublicProfile(profileId);
        if (!profile || !profile.presenceId) {
            return false;
        }

        return await this.deletePresence(profile.presenceId);
    }

    async getProfilesInArea(
        latitude: string,
        longitude: string,
        radiusKm: string
    ) {
        const lat = this.handler.decimal(latitude);
        const lng = this.handler.decimal(longitude);
        const rad = this.handler.decimal(radiusKm);

        this.validateCoords(lat, lng);

        const profiles = await this.handler.getProfilesInArea(lat, lng, rad);

        return profiles.map((profile) => ({
            id: profile.id,
            handle: profile.handle,
            displayName: profile.displayName,
            biography: profile.biography,
            createdAt: profile.createdAt,
            precense: {
                latitude: profile.fakePresence?.latitude,
                longitude: profile.fakePresence?.longitude,
            },
        }));
    }
}
