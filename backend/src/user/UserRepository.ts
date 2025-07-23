import { IUserHandler } from "./IUserHandler.ts";
import { prisma } from "../database.ts";
import { Prisma, User } from "../generated/prisma/client.ts";
import { hasher } from "../authentication/hashing.ts";
import { CustomValidationError } from "../errors.ts";

export class UserRepository implements IUserHandler {
    async getUser(username: string): Promise<User | null> {
        return await prisma.user.findUnique({ where: { username: username } });
    }

    async registerUser(username: string, password: string) {
        const passwordHash = await hasher.hash(password);
        try {
            await prisma.profile.create({
                data: {
                    handle: username,
                    profileOwnerIndex: 0,
                    owner: {
                        create: { username, passwordHash },
                    },
                },
            });
        } catch (err) {
            if (
                err instanceof Prisma.PrismaClientKnownRequestError &&
                err.code === "P2002"
            ) {
                throw new CustomValidationError({"username": "Username is already taken."});
            }

            throw err; // rethrow other errors
        }
    }
}
