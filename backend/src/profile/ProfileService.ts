import { IProfileHandler } from "./IProfileHandler.ts";

export class ProfileService {
    handler: IProfileHandler;

    constructor(handler: IProfileHandler) {
        this.handler = handler;
    }

    async getProfile(ownerId: number, index: number) {
        return await this.handler.getProfileByOwner(index, ownerId);
    }

    async getMyProfiles(userId: number) {
        return await this.handler.getMyProfiles(userId);
    }

    async updateProfile(id: number, displayName?: string, biography?: string) {
        return await this.handler.updateProfile(id, displayName, biography);
    }

    async getFullPublicProfile(id: number) {
        return await this.handler.getPublicProfile(id);
    }

    async getPublicProfile(id: number) {
        const profile = await this.handler.getPublicProfile(id);
        if (profile === null) {
            return null;
        }

        return {
            handle: profile.handle,
            displayName: profile.displayName,
            biography: profile.biography,
            createdAt: profile.createdAt,
            precense: {
                longitude: profile.presence?.longitude,
                latitude: profile.presence?.latitude,
            }
        };
    }
}