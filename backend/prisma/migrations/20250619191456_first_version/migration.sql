/*
  Warnings:

  - You are about to drop the `LPSessionRequest` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ProfileDisplay` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `username` on the `AuthSession` table. All the data in the column will be lost.
  - The primary key for the `LPSessionParticipation` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `LPSessionParticipation` table. All the data in the column will be lost.
  - The primary key for the `Swipe` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `Swipe` table. All the data in the column will be lost.
  - Added the required column `userId` to the `AuthSession` table without a default value. This is not possible if the table is not empty.
  - Added the required column `name` to the `LPSession` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `LPSessionParticipation` table without a default value. This is not possible if the table is not empty.
  - Added the required column `handle` to the `Profile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `profileOwnerIndex` to the `Profile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Swipe` table without a default value. This is not possible if the table is not empty.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "LPSessionRequest";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "ProfileDisplay";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "MusicDisplay" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "profileId" INTEGER NOT NULL,
    CONSTRAINT "MusicDisplay_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL,
    "message" TEXT,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "sessionId" INTEGER,
    "senderId" INTEGER,
    "recipientId" INTEGER NOT NULL,
    CONSTRAINT "Notification_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "LPSession" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Notification_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "Profile" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Notification_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AuthSession" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "secureId" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "validUntil" DATETIME NOT NULL,
    CONSTRAINT "AuthSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_AuthSession" ("id", "secureId", "validUntil") SELECT "id", "secureId", "validUntil" FROM "AuthSession";
DROP TABLE "AuthSession";
ALTER TABLE "new_AuthSession" RENAME TO "AuthSession";
CREATE UNIQUE INDEX "AuthSession_secureId_key" ON "AuthSession"("secureId");
CREATE TABLE "new_LPSession" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "creatorId" INTEGER NOT NULL,
    "presenceId" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    CONSTRAINT "LPSession_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LPSession_presenceId_fkey" FOREIGN KEY ("presenceId") REFERENCES "MapPresence" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_LPSession" ("createdAt", "creatorId", "id", "presenceId", "status", "updateAt") SELECT "createdAt", "creatorId", "id", "presenceId", "status", "updateAt" FROM "LPSession";
DROP TABLE "LPSession";
ALTER TABLE "new_LPSession" RENAME TO "LPSession";
CREATE TABLE "new_LPSessionParticipation" (
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "status" TEXT NOT NULL,
    "participantId" INTEGER NOT NULL,
    "sessionId" INTEGER NOT NULL,

    PRIMARY KEY ("participantId", "sessionId"),
    CONSTRAINT "LPSessionParticipation_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LPSessionParticipation_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "LPSession" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_LPSessionParticipation" ("createdAt", "participantId", "sessionId", "updateAt") SELECT "createdAt", "participantId", "sessionId", "updateAt" FROM "LPSessionParticipation";
DROP TABLE "LPSessionParticipation";
ALTER TABLE "new_LPSessionParticipation" RENAME TO "LPSessionParticipation";
CREATE TABLE "new_Profile" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "ownerId" INTEGER NOT NULL,
    "profileOwnerIndex" INTEGER NOT NULL,
    "handle" TEXT NOT NULL,
    "displayName" TEXT,
    "biography" TEXT,
    "presenceId" INTEGER,
    "fakePresenceId" INTEGER,
    CONSTRAINT "Profile_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Profile_presenceId_fkey" FOREIGN KEY ("presenceId") REFERENCES "MapPresence" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Profile_fakePresenceId_fkey" FOREIGN KEY ("fakePresenceId") REFERENCES "MapPresence" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Profile" ("biography", "createdAt", "displayName", "id", "ownerId", "presenceId", "updateAt") SELECT "biography", "createdAt", "displayName", "id", "ownerId", "presenceId", "updateAt" FROM "Profile";
DROP TABLE "Profile";
ALTER TABLE "new_Profile" RENAME TO "Profile";
CREATE UNIQUE INDEX "Profile_ownerId_profileOwnerIndex_key" ON "Profile"("ownerId", "profileOwnerIndex");
CREATE TABLE "new_Swipe" (
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "swiperId" INTEGER NOT NULL,
    "swipeeId" INTEGER NOT NULL,

    PRIMARY KEY ("swiperId", "swipeeId"),
    CONSTRAINT "Swipe_swiperId_fkey" FOREIGN KEY ("swiperId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Swipe_swipeeId_fkey" FOREIGN KEY ("swipeeId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Swipe" ("createdAt", "swipeeId", "swiperId") SELECT "createdAt", "swipeeId", "swiperId" FROM "Swipe";
DROP TABLE "Swipe";
ALTER TABLE "new_Swipe" RENAME TO "Swipe";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

-- CreateIndex
CREATE UNIQUE INDEX "MusicDisplay_profileId_key" ON "MusicDisplay"("profileId");
