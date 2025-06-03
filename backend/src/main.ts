import { mklog } from "./logger.ts";
import { hasher } from "./passwords/hashing.ts";
import userController from "./user/user.ts";

const log = mklog("main");

const main = async () => {
    log.info("Launching LocalPlayer Backend");

    await userController.register("kevin", "mypasswordhaha!");
    log.info("created user!");

    // "log in" user
    const password = "notmypassword!";
    const user = await userController.getUser("kevin");
    if (user === null) {
        log.error("No user found!");
        return;
    }

    if (await hasher.verify(user.passwordHash, password)) {
        log.info("Correct password!");
    } else {
        log.error("Wrong password");
    }
};

main().finally(() => {
    log.info("Shutting down");
});
