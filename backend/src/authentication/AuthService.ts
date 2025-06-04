import { Elysia, t } from "elysia";
import { isSessionValid, Session } from "./Session.ts";
import { mklog } from "../logger.ts";
import { UNAUTHORIZED } from "../errors.ts";

const log = mklog("auth");

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
            resolve({ status, cookie: { id }, store: { sessions } }) {
                if (!id?.value) {
                    log.http("No session was given");
                    return status(401, UNAUTHORIZED);
                }

                const sessionId = id.value;

                const session = sessions[sessionId];

                if (!session) {
                    log.http(`Session ${sessionId} was not found in the session store`);
                    return status(401, UNAUTHORIZED);
                }


                if (!isSessionValid(session)) {
                    log.http(`Session ${session} has expired`);
                    delete sessions[sessionId];
                    return status(401, UNAUTHORIZED);
                }

                return { userId: session.userId, sessionId: sessionId };
            },
        },
    });
