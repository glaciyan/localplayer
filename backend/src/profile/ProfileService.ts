import { ProfileRepository } from "./ProfileRepository.ts";

export class ProfileService {
    handler: ProfileRepository;

    constructor(handler: ProfileRepository) {
        this.handler = handler;
    }

    async getProfile(ownerId: number, index: number) {
        return await this.handler.getProfileByOwner(index, ownerId);
    }

    async getPublicProfile(id: number) {
        return await this.handler.getPublicProfile(id);
    }

    async getMyProfiles(userId: number) {
        return await this.handler.getMyProfiles(userId);
    }

    async updateProfile(
        id: number,
        displayName?: string,
        biography?: string,
        spotifyLink?: string
    ) {
        return await this.handler.updateProfile(
            id,
            displayName,
            biography,
            spotifyLink
        );
    }
}
