import { ElysiaSwaggerConfig } from "@elysiajs/swagger";

export const swaggerConfig = {
    documentation: {
        info: {
            title: "LocalPlayer API Documentation",
            version: "v1",
            description: "Bing Bong",
        },
    },
} satisfies ElysiaSwaggerConfig<"/swagger">;
