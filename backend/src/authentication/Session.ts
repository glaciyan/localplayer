export interface Session {
    validTo: Date;
    userId: string;
}

export const isSessionValid = (session: Session) => {
    const now = new Date();
    return now <= session.validTo;
}
