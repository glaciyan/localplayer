import { mklog } from "../logger.ts";
import { ProfileRepository } from "./ProfileRepository.ts";
import { ProfileService } from "./ProfileService.ts";

const log = mklog("profile");

log.info("Starting Profile Service");
const repo = new ProfileRepository();
const profileController = new ProfileService(repo);
export default profileController;