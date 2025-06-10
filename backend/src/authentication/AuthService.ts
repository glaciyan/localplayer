import { Cookie, Elysia, t } from "elysia";
import { mklog } from "../logger.ts";
import { UNAUTHORIZED } from "../errors.ts";
import { sessionController } from "./session/session.ts";
import profileController from "../profile/profile.ts";

const log = mklog("auth");

const resolveSession = async (id: Cookie<string | undefined> | undefined, request: Request) => {
    if (!id?.value) {
        log.http("No session was given");
        return false;
    }

    const sessionId = id.value;

    const session = await sessionController.getSession(sessionId);

    if (!session) {
        log.http(`Session ${sessionId} was not found in the session store`);
        return false;
    }

    log.http(`${session.user.id}:${session.user.username} ${request.method} ${request.url}`)

    return { user: session.user, sessionId: sessionId };
};

export const AuthService = new Elysia() //
    .model({
        optionalSession: t.Cookie({
            id: t.Optional(t.String()),
        }),
        session: t.Cookie({
            id: t.String(),
        }),
        userAuth: t.Object({
            name: t.String({
                minLength: 3,
                maxLength: 14,
                pattern: "^[a-zA-Z0123456789_]*$",
            }),
            password: t.String({ minLength: 8, maxLength: 200 }),
        }),
    })
    .macro({
        requireSession: {
            async resolve({ status, cookie: { id }, request }) {
                const session = await resolveSession(id, request);
                if (session === false) {
                    return status(401, UNAUTHORIZED);
                }

                return session;
            },
        },
        requireProfile: {
            async resolve({ status, cookie: { id }, headers, request }) {
                const session = await resolveSession(id, request);

                if (session === false) {
                    return status(401, UNAUTHORIZED);
                }

                const profileIndex = headers["x-profile-index"] || "0";

                if (!profileIndex) {
                    log.http(
                        "No profile index header (x-profile-index) was provided"
                    );
                    return status(
                        400,
                        "Profile index header (x-profile-index) is required"
                    );
                }
                const index_parsed = parseInt(profileIndex);
                if (isNaN(index_parsed)) {
                    log.http(`Invalid profile index provided: ${profileIndex}`);
                    return status(400, "Invalid profile ID");
                }

                const profile = await profileController.getProfile(
                    session.user.id,
                    index_parsed
                );
                if (profile === null) {
                    log.http(`Profile ${index_parsed} not found`);
                    return status(403, UNAUTHORIZED);
                }

                if (profile.ownerId !== session.user.id) {
                    log.http(
                        `User ${session.user.username} attempted to access profile ${index_parsed} owned by user ${profile.ownerId}`
                    );
                    return status(403, UNAUTHORIZED);
                }

                return {
                    user: session.user,
                    sessionId: session.sessionId,
                    profile: profile,
                };
            },
        },
    });
