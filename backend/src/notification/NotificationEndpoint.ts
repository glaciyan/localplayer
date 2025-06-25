import { Elysia } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import { notificationController } from "./notification.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { SessionDTOMapWithoutParticipants } from "../session/SessionEndpoint.ts";

export const NotificationDTOMap = async (notif: any) => ({
    id: notif.id,
    type: notif.type,
    createdAt: notif.createdAt,
    title: notif.title,
    message: notif.message,
    read: notif.read,
    sender: await ProfileDTOMap(notif.sender),
    session: notif.session
        ? await SessionDTOMapWithoutParticipants(notif.session)
        : null,
});

export const NotificationEndpoint = new Elysia({ prefix: "notification" }) //
    .use(AuthService)
    .get(
        "/",
        async ({ profile }) => {
            const notifications = await notificationController.getNotifications(
                profile.id
            );
            return await Promise.all(
                notifications.map((n) => NotificationDTOMap(n))
            );
        },
        {
            requireProfile: true,
            detail: {
                description: "Get all your notifications.",
            },
        }
    );
