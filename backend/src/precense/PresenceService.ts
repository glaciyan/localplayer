import { IPresenceHandler } from "./IPresenceHandler.ts";
import profileController from "../profile/profile.ts";

export class PresenceService {
    handler: IPresenceHandler;

    constructor(handler: IPresenceHandler) {
        this.handler = handler;
    }

    async getPresence(id: number) {
        return await this.handler.getPresence(id);
    }

    async createPresence(latitude: number, longitude: number) {
        return await this.handler.createPresence(latitude, longitude);
    }

    async updatePresence(id: number, latitude: number, longitude: number) {
        return await this.handler.updatePresence(id, latitude, longitude);
    }

    async deletePresence(id: number) {
        return await this.handler.deletePresence(id);
    }

    async setProfilePresence(
        profileId: number,
        latitude: number,
        longitude: number
    ) {
        // Get current profile to check if it has a presence
        const profile = await profileController.getFullPublicProfile(profileId);
        if (!profile) {
            return null;
        }

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
                latitude,
                longitude
            );
        }

        return presence;
    }

    async removeProfilePresence(profileId: number) {
        const profile = await profileController.getFullPublicProfile(profileId);
        if (!profile || !profile.presenceId) {
            return false;
        }

        // Remove presence reference from profile first
        // Note: You'll need to add a method to update presenceId to null in ProfileService

        // Then delete the presence
        return await this.deletePresence(profile.presenceId);
    }

    async getProfilesInArea(
        latitude: number,
        longitude: number,
        radius: number
    ) {
        const profiles = await this.handler.getProfilesInArea(
            latitude,
            longitude,
            radius
        );

        // Return public profile information only
        return profiles.map((profile) => ({
            id: profile.id,
            handle: profile.handle,
            displayName: profile.displayName,
            biography: profile.biography,
            createdAt: profile.createdAt,
        }));
    }
}
