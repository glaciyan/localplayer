import { status } from "elysia";

export type ErrorCode =
    | "auth/no-session"
    | "auth/invalid-credentials"
    | "auth/invalid-profile"
    | "validation/invalid-input"
    | "server/internal-server-error"
    | "db/unique-constraint"
    | "db/query-failed"
    | "not-found/resource"
    | "not-found/endpoint"
    | "request/invalid-file-type"
    | "request/parse-error"
    | "security/invalid-cookie-signature"
    | "profile/profile-not-found"
    | "auth/no-secret"
    | "presence/not-found"
    | "session/already-open"
    | "session/not-found"
    | "spotify/song-not-found"
    | "swipe/cant-rate-yourself"
    | "swipe/already-rated";

export type GenericError = {
    code: ErrorCode;
    message: string;
    fieldErrors?: { [field: string]: string };
};

export const ErrorTemplates = {
    AUTH_NOSESSION: {
        code: "auth/no-session",
        message: "Authentication required.",
    },
    INVALID_CREDENTIALS: {
        code: "auth/invalid-credentials",
        message: "Wrong username or password.",
    },
    INVALID_PROFILE: {
        code: "auth/invalid-profile",
        message: "The profile you're trying to log into is invalid.",
    },
    INVALID_INPUT: {
        code: "validation/invalid-input",
        message:
            "Some of the information you entered is invalid. Please review and try again.",
    },
    INTERNAL_SERVER_ERROR: {
        code: "server/internal-server-error",
        message: "An unexpected error occurred. Please try again later.",
    },
    DB_UNIQUE_CONSTRAINT: {
        code: "db/unique-constraint",
        message: "A unique constraint failed in the database.",
    },
    DB_QUERY_FAILED: {
        code: "db/query-failed",
        message: "Database query failed unexpectedly.",
    },
    NOT_FOUND_RESOURCE: {
        code: "not-found/resource",
        message: "The requested resource was not found.",
    },
    NOT_FOUND_ENDPOINT: {
        code: "not-found/endpoint",
        message: "The requested endpoint does not exist.",
    },
    INVALID_FILE_TYPE: {
        code: "request/invalid-file-type",
        message: "The uploaded file type is not supported.",
    },
    PARSE_ERROR: {
        code: "request/parse-error",
        message: "Failed to parse the request.",
    },
    INVALID_COOKIE_SIGNATURE: {
        code: "security/invalid-cookie-signature",
        message: "Invalid Cookie Signature.",
    },
    PROFILE_NOT_FOUND: {
        code: "profile/profile-not-found",
        message: "Profile not found.",
    },
    NO_SECRET: {
        code: "auth/no-secret",
        message: "Unauthorized",
    },
    PRESENCE_NOT_FOUND: {
        code: "presence/not-found",
        message: "No presence set for this profile.",
    },
    SESSION_ALREADY_OPEN: {
        code: "session/already-open",
        message: "You have already opened a session.",
    },
    SESSION_NOT_FOUND: {
        code: "session/not-found",
        message: "Session not found.",
    },
    SPOTIFY_SONG_NOT_FOUND: {
        code: "spotify/song-not-found",
        message: "Spotify track does not exist.",
    },
    SWIPE_CANT_RATE_YOURSELF: {
        code: "swipe/cant-rate-yourself",
        message: "You cannot rate yourself.",
    },
    USER_ALREADY_RATED: {
        code: "swipe/already-rated",
        message: "You have already rated this user.",
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

export class ApiError extends GenericCustomError {}

export class CustomValidationError extends GenericCustomError {
    constructor(fieldErrors: { [field: string]: string }) {
        super({ ...ErrorTemplates.INVALID_INPUT, fieldErrors });
    }
}

export class AuthenticationError extends GenericCustomError {}

export class NotFoundError extends GenericCustomError {
    constructor() {
        super(ErrorTemplates.NOT_FOUND_ENDPOINT);
    }
}

export class ProfileNotFoundError extends GenericCustomError {
    constructor() {
        super(ErrorTemplates.PROFILE_NOT_FOUND);
    }
}

export class UnknownError extends GenericCustomError {
    constructor(message?: string) {
        if (message) {
            super({ code: "server/internal-server-error", message });
        } else {
            super(ErrorTemplates.INTERNAL_SERVER_ERROR);
        }
    }
}
