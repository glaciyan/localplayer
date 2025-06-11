import { mklog } from "../logger.ts";
import { NotificationService } from "./NotificationService.ts";

const log = mklog("notification");

log.info("Starting Notification Service");
export const notificationController = new NotificationService();
