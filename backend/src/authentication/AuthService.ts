import { Elysia, t } from "elysia";
import { mklog } from "../logger.ts";
import { UNAUTHORIZED } from "../errors.ts";
import { sessionController } from "./session/session.ts";

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
            async resolve({ status, cookie: { id } }) {
                if (!id?.value) {
                    log.http("No session was given");
                    return status(401, UNAUTHORIZED);
                }

                const sessionId = id.value;

                const session = await sessionController.getSession(id.value);

                if (!session) {
                    log.http(`Session ${sessionId} was not found in the session store`);
                    return status(401, UNAUTHORIZED);
                }

                return { user: session.user, sessionId: sessionId };
            },
        },
    });
