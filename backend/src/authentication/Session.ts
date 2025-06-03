import { addSeconds } from "date-fns";

export interface Session {
    validTo: Date;
    userId: string;
}

export const isSessionValid = (session: Session) => {
    const now = new Date();
    return now <= session.validTo;
};

export const createSession = (
    userId: string,
    validForSeconds: number
): Session => ({
    userId: userId,
    validTo: addSeconds(new Date(), validForSeconds),
});

export const createRefreshedSession = (
    session: Session,
    validForSeconds: number
): Session => ({
    ...session,
    validTo: addSeconds(new Date(), validForSeconds),
});
