export const UNAUTHORIZED = {
    type: "UNAUTHORIZED",
    message: "You need to be logged in to access this endpoint",
};

export class CustomValidationError extends Error {
    constructor(message: string) {
        super(message);
    }
}
