/*
  Warnings:

  - Added the required column `service` to the `MusicDisplay` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tackId` to the `MusicDisplay` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `Notification` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Profile" ADD COLUMN "spotifyId" TEXT;

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_MusicDisplay" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "service" TEXT NOT NULL,
    "tackId" TEXT NOT NULL,
    "profileId" INTEGER NOT NULL,
    CONSTRAINT "MusicDisplay_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_MusicDisplay" ("createdAt", "id", "profileId", "updateAt") SELECT "createdAt", "id", "profileId", "updateAt" FROM "MusicDisplay";
DROP TABLE "MusicDisplay";
ALTER TABLE "new_MusicDisplay" RENAME TO "MusicDisplay";
CREATE UNIQUE INDEX "MusicDisplay_profileId_key" ON "MusicDisplay"("profileId");
CREATE TABLE "new_Notification" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL,
    "message" TEXT,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT NOT NULL,
    "sessionId" INTEGER,
    "senderId" INTEGER,
    "recipientId" INTEGER NOT NULL,
    CONSTRAINT "Notification_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "LPSession" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Notification_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "Profile" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Notification_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Notification" ("createdAt", "id", "message", "read", "recipientId", "senderId", "sessionId", "title") SELECT "createdAt", "id", "message", "read", "recipientId", "senderId", "sessionId", "title" FROM "Notification";
DROP TABLE "Notification";
ALTER TABLE "new_Notification" RENAME TO "Notification";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
