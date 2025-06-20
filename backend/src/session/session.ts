import { mklog } from "../logger.ts";
import { LPSessionService } from "./LPSessionService.ts";

const log = mklog("lpsession");

log.info("Starting LPSession Service");
const lpsessionController = new LPSessionService();
export default lpsessionController;
