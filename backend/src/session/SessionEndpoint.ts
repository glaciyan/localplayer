import { Elysia, t } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";

export const SessionEndpoint = new Elysia({ prefix: "session" }) //
    .use(AuthService)
    .model({
        sessionParams: t.Object({
            latitude: t.String(),
            longitude: t.String(),
        }),
    })
    .get("/", () => "hi")
    .post(
        "/",
        () => {
            //
        },
        {
            cookie: "session",
            requireProfile: true,
        }
    );
