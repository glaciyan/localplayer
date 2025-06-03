import { IUserHandler } from "./IUserHandler.ts";

export class UserService {
    handler: IUserHandler;

    constructor(handler: IUserHandler) {
        this.handler = handler;
    }

    register(username: string, password: string) {
        return this.handler.registerUser(username, password);
    }

    getUser(username: string) {
        return this.handler.getUser(username);
    }
}
