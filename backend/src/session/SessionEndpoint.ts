import { Elysia } from "elysia";

export const SessionEndpoint = new Elysia({ prefix: "session" }) //
    .get("/", () => "hi");
