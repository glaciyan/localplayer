import { User } from "../generated/prisma/client.ts";

export interface IUserHandler {
    getUser(username: string): Promise<User | null>;
    registerUser(username: string, password: string): Promise<boolean>;
}
