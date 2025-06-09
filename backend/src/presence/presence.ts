import { mklog } from "../logger.ts";
import { PresenceRepository } from "./PresenceRepository.ts";
import { PresenceService } from "./PresenceService.ts";

const log = mklog("presence");

log.info("Starting Presence Service");
const repo = new PresenceRepository();
const presenceController = new PresenceService(repo);
export default presenceController;