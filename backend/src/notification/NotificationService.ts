import { prisma } from "../database.ts";
import { SortOrder } from "../generated/prisma/internal/prismaNamespace.ts";
import { mklog } from "../logger.ts";
import { SessionIncludes } from "../session/LPSessionService.ts";

const log = mklog("notification");

export class NotificationService {
    async createNotification({
        from,
        to,
        title,
        message,
        lpSessionId,
    }: {
        from: number;
        to: number;
        title: string;
        message: string | null;
        lpSessionId?: number;
    }) {
        log.info(
            `Sending notification "${title}" from pid:${from}, to pid:${to}`
        );

        const notification = await prisma.notification.create({
            data: {
                sender: {
                    connect: {
                        id: from,
                    },
                },
                recipient: {
                    connect: {
                        id: to,
                    },
                },
                ...(lpSessionId && {
                    session: {
                        connect: {
                            id: lpSessionId,
                        },
                    },
                }),
                title,
                message,
                read: false,
            },
        });

        return notification;
    }

    async getNotifications(profileId: number) {
        const notifications = await prisma.notification.findMany({
            where: {
                recipientId: profileId,
            },
            include: {
                sender: true,
                session: {
                    include: SessionIncludes,
                },
            },
            orderBy: {
                createdAt: SortOrder.desc,
            },
        });

        return notifications;
    }

    async markAsRead(notificationId: number, read: boolean) {
        const udpated = await prisma.notification.update({
            where: {
                id: notificationId,
            },
            data: {
                read: read,
            },
        });

        return udpated;
    }

    async markAllAsRead(profileId: number) {
        const result = await prisma.notification.updateMany({
            where: {
                recipientId: profileId,
            },
            data: {
                read: true,
            },
        });

        return result.count;
    }
}
