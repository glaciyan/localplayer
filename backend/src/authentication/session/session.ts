import { ISessionHandler } from "./ISessionHandler.ts";
import { SessionRepository } from "./SessionRepository.ts";
import { SessionService } from "./SessionService.ts";

const handler: ISessionHandler = new SessionRepository();
export const sessionController =  new SessionService(handler);
