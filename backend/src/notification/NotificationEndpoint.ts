import { Elysia } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import { notificationController } from "./notification.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { SessionDTOMapWithoutParticipants } from "../session/SessionEndpoint.ts";

export const NotificationDTOMap = (notif: any) => ({
    createdAt: notif.createdAt,
    title: notif.title,
    message: notif.message,
    read: notif.read,
    sender: ProfileDTOMap(notif.sender),
    session: notif.session ? SessionDTOMapWithoutParticipants(notif.session) : null
});

export const NotificationEndpoint = new Elysia({ prefix: "notification" }) //
    .use(AuthService)
    .get(
        "/",
        async ({ profile }) => {
            const notifications = await notificationController.getNotifications(
                profile.id
            );
            return notifications.map((n) => NotificationDTOMap(n));
        },
        {
            cookie: "session",
            requireProfile: true,
        }
    );
