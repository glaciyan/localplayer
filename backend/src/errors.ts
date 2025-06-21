export const UNAUTHORIZED = "You need to be logged in.";

export class CustomValidationError extends Error {
    constructor(message: string) {
        super(message);
    }
}
