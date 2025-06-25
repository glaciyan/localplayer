import { Elysia, status, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import { notificationController } from "../notification/notification.ts";
import profileController from "../profile/profile.ts";
import { mklog } from "../logger.ts";

const log = mklog("ping");

export const PingEndpoint = new Elysia({ prefix: "ping" })
    .use(AuthService)
    .post(
        "/:profileId",
        async ({ profile, params: { profileId } }) => {
            log.info(`Ping to ${profileId}`);
            const profiles = await profileController.getPublicProfile(profileId);
            if (!profiles) {
                return status(404);
            }

            await notificationController.createNotification({
                from: profile.id,
                to: profileId,
                title: `${
                    profile.displayName || profile.handle
                } pinged you`,
                message: null,
                notifType: "PING",
            });

            return status(200);
        },
        {
            requireProfile: true,
            params: t.Object({
                profileId: t.Number(),
            }),
        }
    );
