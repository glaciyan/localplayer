import { mklog } from "../logger.ts";
import { UserRepository } from "./UserRepository.ts";
import { UserService } from "./UserService.ts";

const log = mklog("user");

log.info("Starting User Service");
const repo = new UserRepository();
const userController = new UserService(repo);
export default userController;
