import { hasher } from "../authentication/hashing.ts";
import { IUserHandler } from "./IUserHandler.ts";

export class UserService {
    handler: IUserHandler;

    constructor(handler: IUserHandler) {
        this.handler = handler;
    }

    register(username: string, password: string) {
        return this.handler.registerUser(username, password);
    }

    async getPublicUser(username: string) {
        const user = await this.handler.getUser(username);
        if (user === null) {
            return null;
        }

        return {
            id: user.id,
            username: user.username
        }
    }

    async authenticateUser(username: string, password: string) {
        const user = await this.handler.getUser(username);
        if (user === null) {
            return null;
        }

        return await hasher.verify(user.passwordHash, password) ? user : null;
    }
}
