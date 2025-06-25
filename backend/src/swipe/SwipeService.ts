import { prisma } from "../database.ts";
import { SwipeType } from "../generated/prisma/enums.ts";
import { SortOrder } from "../generated/prisma/internal/prismaNamespace.ts";
import { PublicProfileIncludes } from "../profile/ProfileRepository.ts";

export class SwipeService {
    async createSwipe(swiperId: number, swipeeId: number, rating: SwipeType) {
        try {
            return await prisma.swipe.create({
                data: {
                    swipee: {
                        connect: {
                            id: swipeeId,
                        },
                    },
                    swiper: {
                        connect: {
                            id: swiperId,
                        },
                    },
                    type: rating,
                },
            });
        } catch {
            return null;
        }
    }

    async getSwipeCandidates(profileId: number) {
        const candidates = await prisma.profile.findMany({
            where: {
                swipesReceived: {
                    every: {
                        swiperId: {
                            not: profileId,
                        },
                    },
                },
                id: {
                    not: profileId,
                },
            },
            orderBy: {
                createdAt: SortOrder.asc,
            },
            include: PublicProfileIncludes
        });

        return candidates;
    }
}
