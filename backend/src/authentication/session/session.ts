import { mklog } from "../../logger.ts";
import { ISessionHandler } from "./ISessionHandler.ts";
import { SessionRepository } from "./SessionRepository.ts";
import { SessionService } from "./SessionService.ts";

const log = mklog("session");

log.info("Starting Session Service");
const handler: ISessionHandler = new SessionRepository();
export const sessionController =  new SessionService(handler);
