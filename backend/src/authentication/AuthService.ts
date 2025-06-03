import { Elysia, t } from "elysia";
import { isSessionValid, Session } from "./Session.ts";
import { mklog } from "../logger.ts";

const log = mklog("auth");

export const AuthService = new Elysia() //
    .state({
        sessions: {} as Record<string, Session>,
    })
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
            resolve({ status, cookie: { id }, store: { sessions } }) {
                if (!id?.value) {
                    log.warn("No session was given");
                    return status(401, {
                        success: false,
                        message: "Unauthorized",
                    });
                }

                const sessionId = id.value;

                const session = sessions[sessionId];

                if (!session) {
                    log.warn(
                        `Session was not found in the session store`
                    );
                    return status(401, {
                        success: false,
                        message: "Unauthorized",
                    });
                }

                if (!isSessionValid(session)) {
                    log.warn(`Session ${session} has expired`);
                    delete sessions[sessionId];
                    return status(401, {
                        success: false,
                        message: "Unauthorized, session expired",
                    });
                }

                return { userId: session.userId, sessionId: sessionId };
            },
        },
    });
