import { Elysia, status, t } from "elysia";
import userController from "./user.ts";

export const UserEndpoint = new Elysia({ prefix: "/user" })
    .get("/:id", async ({ params: { id } }) => {
        const user = await userController.getUser(id);
        if (user === null) {
            return status(404, "User Not Found");
        }

        return user;
    })
    .post(
        "/signup",
        async ({ body }) => {
            await userController.register(body.name, body.password);
            return status(200);
        },
        {
            body: t.Object({ name: t.String(), password: t.String() }),
        }
    );
