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
        const User = await prisma.user.create({
            data: { username, passwordHash },
        });
        return User;
    }
}
