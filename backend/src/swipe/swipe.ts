import { mklog } from "../logger.ts";
import { SwipeService } from "./SwipeService.ts";

const log = mklog("swipe");

log.info("Starting Swipe Service");
export const swipeController = new SwipeService();
