import { Elysia, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import { swipeController } from "./swipe.ts";
import { ProfileDTOMap } from "../profile/ProfileEndpoint.ts";
import { notificationController } from "../notification/notification.ts";
import { mklog } from "../logger.ts";
import { ApiError, ErrorTemplates } from "../errors.ts";

const log = mklog("swipe");

enum RatingOptions {
    good = "good",
    bad = "bad",
}

export const SwipeEndpoint = new Elysia({ prefix: "swipe" }) //
    .use(AuthService)
    .post(
        "/:rating/:swipeeId",
        async ({ params: { swipeeId, rating }, profile }) => {
            if (profile.id === swipeeId) {
                throw new ApiError(ErrorTemplates.SWIPE_CANT_RATE_YOURSELF);
            }
            const result = await swipeController.createSwipe(
                profile.id,
                swipeeId,
                rating === "good" ? "POSITIVE" : "NEGATIVE"
            );

            if (result === null) {
                throw new ApiError(ErrorTemplates.USER_ALREADY_RATED);
            }

            if (rating === "good") {
                await notificationController.createNotification({
                    from: profile.id,
                    to: swipeeId,
                    title: `${
                        profile.displayName || profile.handle
                    } liked your profile.`,
                    notifType: "LIKED",
                    message: null,
                });
            } else if (rating === "bad") {
                await notificationController.createNotification({
                    from: profile.id,
                    to: swipeeId,
                    title: `${
                        profile.displayName || profile.handle
                    } disliked your profile!`,
                    notifType: "DISLIKED",
                    message: null,
                });
            }

            return result;
        },
        {
            requireProfile: true,
            params: t.Object({
                swipeeId: t.Number(),
                rating: t.Enum(RatingOptions),
            }),
            detail: {
                description:
                    "Rate another user using swipe, set rating to either `good` or `bad`.",
            },
        }
    )
    .get(
        "/candidates",
        async ({ profile }) => {
            const candidates = await swipeController.getSwipeCandidates(
                profile.id
            );
            log.info(`Found ${candidates.length} candiates`);
            return await Promise.all(candidates.map((c) => ProfileDTOMap(c)));
        },
        {
            requireProfile: true,
            detail: {
                description: "Get a list of profiles for the swiping cards.",
            },
        }
    );
