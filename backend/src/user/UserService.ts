import { IUserHandler } from "./IUserHandler.ts";

export class UserService {
    handler: IUserHandler;

    constructor(handler: IUserHandler) {
        this.handler = handler;
    }

    register(username: string, password: string) {
        return this.handler.registerUser(username, password);
    }

    async getUser(username: string) {
        const user = await this.handler.getUser(username);
        if (user === null) {
            return null;
        }

        return {
            id: user.id,
            username: user.username
        }
    }
}
