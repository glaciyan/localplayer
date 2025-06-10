import { mklog } from "../logger.ts";
import { LPSessionService } from "./LPSessionService.ts";

const log = mklog("presence");

log.info("Starting Presence Service");
const lpsessionController = new LPSessionService();
export default lpsessionController;