import { status } from "elysia";

export type ErrorCode =
    | "auth/no-session"
    | "auth/invalid-credentials"
    | "auth/invalid-profile"
    | "validation/invalid-input"
    | "server/internal-server-error";

export type GenericError = {
    code: ErrorCode;
    message?: string;
    fieldErrors?: { [field: string]: string };
};

export const ErrorTemplates = {
    AUTH_NOSESSION: {
        code: "auth/no-session",
        message: "Authentication required.",
    },
    INVALID_INPUT: {
        code: "validation/invalid-input",
    },
    INVALID_CREDENTIALS: {
        code: "auth/invalid-credentials",
        message: "Wrong username or password.",
    },
    INVALID_PROFILE: {
        code: "auth/invalid-profile",
        message: "The profile you're trying to log into is invalid.",
    },
    INTERNAL_SERVER_ERROR: {
        code: "server/internal-server-error",
        message: "An unexpected error occurred. Please try again later.",
    },
} as const satisfies { [key: string]: GenericError };

export const respond = (error: GenericError) => status(400, error);

class GenericCustomError extends Error {
    constructor(public error: GenericError) {
        super();
    }

    toResponse() {
        return respond(this.error);
    }
}

export class CustomValidationError extends GenericCustomError {
    constructor(fieldErrors: { [field: string]: string }) {
        super({ ...ErrorTemplates.INVALID_INPUT, fieldErrors });
    }
}

export class AuthenticationError extends GenericCustomError {}
