import { IUserHandler } from "./IUserHandler.ts";
import { prisma } from "../database.ts";
import { User } from "../generated/prisma/client.ts";
import { hasher } from "../authentication/hashing.ts";

export class UserRepository implements IUserHandler {
    async getUser(username: string): Promise<User | null> {
        return await prisma.user.findUnique({ where: { username: username } });
    }

    async registerUser(username: string, password: string) {
        const passwordHash = await hasher.hash(password);
        const Profile = await prisma.profile.create({
            data: {
                handle: username,
                profileOwnerIndex: 0,
                owner: {
                    create : { username, passwordHash }
                }
            },
        });

        return Profile != null;
    }
}
