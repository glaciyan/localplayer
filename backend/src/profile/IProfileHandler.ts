import { Profile } from "../generated/prisma/client.ts";

export interface IProfileHandler {
    getProfileByOwner(index: number, ownerId: number): Promise<Profile | null>;
    getPublicProfile(id: number): Promise<Profile | null>;
    getMyProfiles(userId: number): Promise<Profile[]>;
    updateProfile(id: number, displayName?: string, biography?: string): Promise<Profile | null>;
}