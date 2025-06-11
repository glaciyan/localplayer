/*
  Warnings:

  - The primary key for the `Session` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - Added the required column `id` to the `Session` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Session" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "secureId" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "validUntil" DATETIME NOT NULL,
    CONSTRAINT "Session_username_fkey" FOREIGN KEY ("username") REFERENCES "User" ("username") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Session" ("secureId", "username", "validUntil") SELECT "secureId", "username", "validUntil" FROM "Session";
DROP TABLE "Session";
ALTER TABLE "new_Session" RENAME TO "Session";
CREATE UNIQUE INDEX "Session_secureId_key" ON "Session"("secureId");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
