import { MapPresence, Profile } from "../generated/prisma/client.ts";

export interface IPresenceHandler {
    getPresence(id: number): Promise<MapPresence | null>;
    createPresence(latitude: number, longitude: number): Promise<MapPresence>;
    createPresenceForProfile(
        profileId: number,
        latitude: number,
        longitude: number
    ): Promise<MapPresence | null>;
    getProfilesInArea(
        latitude: number,
        longitude: number,
        radius: number
    ): Promise<Profile[]>;
    updatePresence(
        id: number,
        latitude: number,
        longitude: number
    ): Promise<MapPresence | null>;
    deletePresence(id: number): Promise<boolean>;
}
