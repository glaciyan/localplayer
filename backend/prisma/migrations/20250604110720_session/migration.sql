-- CreateTable
CREATE TABLE "Session" (
    "secureId" TEXT NOT NULL PRIMARY KEY,
    "username" TEXT NOT NULL,
    "validUntil" DATETIME NOT NULL,
    CONSTRAINT "Session_username_fkey" FOREIGN KEY ("username") REFERENCES "User" ("username") ON DELETE RESTRICT ON UPDATE CASCADE
);
