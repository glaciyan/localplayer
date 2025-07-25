PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "_prisma_migrations" (
    "id"                    TEXT PRIMARY KEY NOT NULL,
    "checksum"              TEXT NOT NULL,
    "finished_at"           DATETIME,
    "migration_name"        TEXT NOT NULL,
    "logs"                  TEXT,
    "rolled_back_at"        DATETIME,
    "started_at"            DATETIME NOT NULL DEFAULT current_timestamp,
    "applied_steps_count"   INTEGER UNSIGNED NOT NULL DEFAULT 0
);
INSERT INTO _prisma_migrations VALUES('36320b41-d717-4e5e-81be-166549f608a0','8f0109eee2982284285dd07338468545958bf60ab087619cc44989326328bdb7',1750857402769,'20250603141348_user',NULL,NULL,1750857402765,1);      
INSERT INTO _prisma_migrations VALUES('cc77681e-3cea-4c47-8329-db3d1aba05e0','9b607cd9fc9e5b0b6150a9f13465d8b4324b50dcb1e3ad797bd159c1bd6afe63',1750857402772,'20250604110720_session',NULL,NULL,1750857402770,1);   
INSERT INTO _prisma_migrations VALUES('26e0211c-db2e-476a-bd70-468a11e8d1c0','937cb4a5ec42a61df2b00aaa72d1adf5d4cdb63bf8ee604fa7a4904e6da6def4',1750857402775,'20250604112621_insucure_session_id',NULL,NULL,1750857402772,1);
INSERT INTO _prisma_migrations VALUES('0fcb903b-4e5c-4f4b-9149-3d0b098db604','dd4be0df53e1f35b92802e20646ff93402218889190000b2cad75c96283e5c86',1750857402782,'20250608191739_additional_data',NULL,NULL,1750857402775,1);
INSERT INTO _prisma_migrations VALUES('66e697e7-e11e-49ad-baa3-b261a91c2abd','d7897ebace2c17e70265d1df3b900fd351b37e99d0d6f88c75f0ca06d7d5df4b',1750857402800,'20250619191456_first_version',NULL,NULL,1750857402783,1);
INSERT INTO _prisma_migrations VALUES('67145c46-07e5-455e-97d1-68015c14a8cf','bb06a942d223dcafcce99b3d55ce5f1be8b25ebf17e1745201de0726594a7c5d',1750857402808,'20250621155610_spotify',NULL,NULL,1750857402802,1);   
INSERT INTO _prisma_migrations VALUES('84f94904-89db-4472-859c-b3f788b8df62','649a7e23b93efb1c679769e616bcf394ddd2b6b05603e8977d4d07b5dbf14f78',1750857402811,'20250625131438_spotify_user_data',NULL,NULL,1750857402808,1);
CREATE TABLE IF NOT EXISTS "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "username" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL
);
INSERT INTO User VALUES(1,'valor123','$argon2id$v=19$m=65536,t=2,p=1$vXyIU/n4eoxs5piOjM3Tdq0K3XPc8XwEio+pgHRsMEs$7G1E7OBaypGbNIrXJHvokmZTyO0avZ8ng8jRLJ2fvww');
INSERT INTO User VALUES(2,'alpinist87','$argon2id$v=19$m=65536,t=2,p=1$hA6ARR1D5qG0zoiaQ/h/51zQMAKutWkjgzQaGpySFYg$zw+Wu8l2sfynqRypS+HxYu5QqeXp+Wvaui5js+//VEQ');
INSERT INTO User VALUES(3,'travelogue','$argon2id$v=19$m=65536,t=2,p=1$rYKSZaUcuac3qNcsU8Ok8UhBYc/IJWigs5ZABO7Yq50$JNIgOY15m0BprWYSAT+WjxoG5wzqtp/mjyKQhUdF3Do');
INSERT INTO User VALUES(4,'jazznut','$argon2id$v=19$m=65536,t=2,p=1$RxgHR08X7KzYVYm4yv5xqItVKWS/maDxfP+M2EEWw80$JAGUyYBV310kOd9KHprU9ZFUYXFfB07gZJnCMCJVaWU');
INSERT INTO User VALUES(5,'techsavvy','$argon2id$v=19$m=65536,t=2,p=1$DyL8peYIRAyuhLYymG7WsXwzGWbzSsAEOp15zHttYNY$xq198xtxGYhaf4+whVAfn7J7FGZGPtv16P+W1ztOfD8');
INSERT INTO User VALUES(6,'artsy_daisy','$argon2id$v=19$m=65536,t=2,p=1$+tlteZuFL9Jx39yHTyoWrm+ydGSYKH+xC69uf7/dN9s$xzybSpJbRz/AYQTkyYsqiqqRs6HQo4P00WWLF7vR6Pc');
INSERT INTO User VALUES(7,'historybuff','$argon2id$v=19$m=65536,t=2,p=1$7r0tRx0PYs7jnaJNPXxXzqlxtz+WN7VMMvCd+5JjJF8$rM2Vn6SP02nJP0IWSATCyOEtHExHK1g0xajDtEsulas');
INSERT INTO User VALUES(8,'biophile','$argon2id$v=19$m=65536,t=2,p=1$HlbEQJ/mSJtrAmkpaQYpmIdwV71piJ0dELSzWVHV83c$nyH/xSvqNBtXdtbQJWj+nRgksyF29cwvlnoNScRqXIU');
INSERT INTO User VALUES(9,'kevin','$argon2id$v=19$m=65536,t=2,p=1$qmtsSpXbb8HbEULZn6mdDcmCyABEgXsYFFvDbTuhHPE$iOLGCKjTedSojKpil+H9tWLVEvx/miijfWAsIkpV9x4');
INSERT INTO User VALUES(10,'kevinn','$argon2id$v=19$m=65536,t=2,p=1$iRp6hBCAyPir9fNR6XSW7peNdNfE0dXfD6gv6ulH1Sw$/tZQOa4VAjzsol3X+P3i2BdioYAV/2msczy87P8GqFE');
INSERT INTO User VALUES(11,'globuli94','$argon2id$v=19$m=65536,t=2,p=1$/x5Zn+kAuhrGVQK6EGqELxscjUTkXrv7Gj+dW8UEg/0$cnrHRvEREVEAcT79q0TWAkejYQnxPbPNa7nCmjipXbI');
INSERT INTO User VALUES(12,'kevin1','$argon2id$v=19$m=65536,t=2,p=1$w15oJZ1VbOO6E5aXzU6DyCss89hU+X20uz6fN99OKsA$IanEugzQfJkvwnWMCoApYO+CEAHB393WFoLQPHa6fNU');
INSERT INTO User VALUES(13,'Arutepsu','$argon2id$v=19$m=65536,t=2,p=1$sCpM303/r2BttUsefLXRSIsJjo50eCDGjYuUz0yr0PE$1tDSL/uhoe2JtpA1CgeRcrNLKWevWJ37vYnMqbsawZs');
INSERT INTO User VALUES(14,'Arutepsu2','$argon2id$v=19$m=65536,t=2,p=1$j8paSn/a0Ds/+eZ82tZFjVH7YaJJCqfwWgOpTWh34bE$0/mRwK6y8Zwow9o5ZtfSckR+i58oTdz5gpWFDX8NaVY');
INSERT INTO User VALUES(15,'malive','$argon2id$v=19$m=65536,t=2,p=1$ZQmuOMlQ03up+ihk0M2HnuSmIGldD4yleuarzEK7e08$dl+R1WoZPhKZNRCN64TDpvl1ne+zEKuHFJespCEF4zY');
INSERT INTO User VALUES(16,'testuser1','$argon2id$v=19$m=65536,t=2,p=1$jWGn/GJBPwJ2HjQkozAJTFjX2zhQdogiTOSoHQeaEb4$6sKIazUTmnMy40d8oNiJ5bE6+BsCGUasFSK8MsVHMyw');
INSERT INTO User VALUES(17,'testinguser123','$argon2id$v=19$m=65536,t=2,p=1$Y2MWfyIWJYmxyKuLoAZMzfAt/VokVkiFGOTkIsWEazQ$ItM7TmCzPt1A38/KOP1UxHbS1CKcoxZBqm1D3CdbVZk');
CREATE TABLE IF NOT EXISTS "MapPresence" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "latitude" DECIMAL NOT NULL,
    "longitude" DECIMAL NOT NULL
);
INSERT INTO MapPresence VALUES(1,52.521157393902697663,13.403740251489422163);
INSERT INTO MapPresence VALUES(2,52.530000000000001136,13.374999999999999999);
INSERT INTO MapPresence VALUES(3,52.510593435698247333,13.442364751147303891);
INSERT INTO MapPresence VALUES(4,52.509999999999998009,13.419999999999999929);
INSERT INTO MapPresence VALUES(5,52.509999999999998009,13.419999999999999929);
INSERT INTO MapPresence VALUES(6,52.53582105036731775,13.434083427094590135);
INSERT INTO MapPresence VALUES(7,52.545000000000001705,13.449999999999999289);
INSERT INTO MapPresence VALUES(8,52.481376850693457923,13.443886619756204581);
INSERT INTO MapPresence VALUES(9,52.494999999999997441,13.429999999999999715);
INSERT INTO MapPresence VALUES(10,52.494999999999997441,13.429999999999999715);
INSERT INTO MapPresence VALUES(11,52.573885909843319553,13.386223864855498532);
INSERT INTO MapPresence VALUES(12,52.560000000000002273,13.390000000000000568);
INSERT INTO MapPresence VALUES(13,52.569273968323614099,13.398919577780930012);
INSERT INTO MapPresence VALUES(14,52.579999999999998292,13.359999999999999431);
INSERT INTO MapPresence VALUES(15,52.503077864328162151,13.50031121959951541);
INSERT INTO MapPresence VALUES(16,52.515000000000000568,13.5);
INSERT INTO MapPresence VALUES(17,52.515000000000000568,13.5);
INSERT INTO MapPresence VALUES(18,52.485482425115222325,13.392369807954976224);
INSERT INTO MapPresence VALUES(19,52.479999999999996872,13.349999999999999644);
INSERT INTO MapPresence VALUES(20,1,1);
INSERT INTO MapPresence VALUES(21,0,0);
INSERT INTO MapPresence VALUES(22,0,0);
INSERT INTO MapPresence VALUES(23,52.556126625775334559,13.49293337474187382);
INSERT INTO MapPresence VALUES(24,52.556378999999999734,13.509095000000000297);
INSERT INTO MapPresence VALUES(25,1,1);
INSERT INTO MapPresence VALUES(26,1,1);
INSERT INTO MapPresence VALUES(27,1,1);
CREATE TABLE IF NOT EXISTS "AuthSession" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "secureId" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "validUntil" DATETIME NOT NULL,
    CONSTRAINT "AuthSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "LPSession" (
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
INSERT INTO LPSession VALUES(1,1750857543191,1750857543191,2,5,'OPEN','EchoNomad''s Session');
INSERT INTO LPSession VALUES(2,1750857544316,1750857544316,4,10,'OPEN','VelvetVoyager''s Session');
INSERT INTO LPSession VALUES(3,1750857545860,1750857545860,7,17,'OPEN','RetroShock''s Session');
INSERT INTO LPSession VALUES(4,1750864153327,1750864153327,9,20,'CLOSED','Kevin Session');
INSERT INTO LPSession VALUES(5,1750864235636,1750864235636,11,21,'CLOSED','''s Session');
INSERT INTO LPSession VALUES(6,1750870428172,1750870430632,14,22,'CONCLUDED','''s Session');
INSERT INTO LPSession VALUES(7,1750874229276,1750874229276,15,25,'CLOSED','Kevin Session');
INSERT INTO LPSession VALUES(8,1750875054443,1750875054443,16,26,'OPEN','Kevin Session');
INSERT INTO LPSession VALUES(9,1750882572058,1750882572058,17,27,'CLOSED','tesing user session');
CREATE TABLE IF NOT EXISTS "LPSessionParticipation" (
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "status" TEXT NOT NULL,
    "participantId" INTEGER NOT NULL,
    "sessionId" INTEGER NOT NULL,

    PRIMARY KEY ("participantId", "sessionId"),
    CONSTRAINT "LPSessionParticipation_participantId_fkey" FOREIGN KEY ("participantId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "LPSessionParticipation_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "LPSession" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO LPSessionParticipation VALUES(1750875671628,1750875671628,'PENDING',16,7);
INSERT INTO LPSessionParticipation VALUES(1750875690124,1750876162293,'ACCEPTED',15,8);
INSERT INTO LPSessionParticipation VALUES(1750882598922,1750882644336,'DECLINED',15,9);
CREATE TABLE IF NOT EXISTS "Profile" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "ownerId" INTEGER NOT NULL,
    "profileOwnerIndex" INTEGER NOT NULL,
    "handle" TEXT NOT NULL,
    "displayName" TEXT,
    "biography" TEXT,
    "presenceId" INTEGER,
    "fakePresenceId" INTEGER, "spotifyId" TEXT, "avatarLink" TEXT, "backgroundLink" TEXT, "followers" INTEGER, "popularity" INTEGER,
    CONSTRAINT "Profile_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Profile_presenceId_fkey" FOREIGN KEY ("presenceId") REFERENCES "MapPresence" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Profile_fakePresenceId_fkey" FOREIGN KEY ("fakePresenceId") REFERENCES "MapPresence" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO Profile VALUES(1,1750857438679,1750857542520,1,0,'valor123','TokyoDrifter','Hi my name is Valor you probably know me from my work on Free.',2,1,'3jLitrUQ5KAF0n9oxUCyqd','https://i.scdn.co/image/ab6761610000e5eb7bf81047bd1cae3a6de4999e','https://i.scdn.co/image/ab6761610000e5eb7bf81047bd1cae3a6de4999e',620,10);
INSERT INTO Profile VALUES(2,1750857438907,1750857543095,2,0,'alpinist87','EchoNomad','Passionate about high-altitude adventures and mountain photography.',4,3,'2VsjQwt2iO5pSWQZ37GKgs','https://i.scdn.co/image/ab6761610000e5eb0e651999de5b170b7dfbfb66','https://i.scdn.co/image/ab6761610000e5eb0e651999de5b170b7dfbfb66',804,22);
INSERT INTO Profile VALUES(3,1750857439222,1750857543720,3,0,'travelogue','NeonWanderer','Exploring the world one city at a time.',7,6,'2dEnUzijJixOkLii3kmu6A','https://i.scdn.co/image/ab6761610000e5eb5eb8778da7b20c931ab65097','https://i.scdn.co/image/ab6761610000e5eb5eb8778da7b20c931ab65097',687,17);
INSERT INTO Profile VALUES(4,1750857439508,1750857544209,4,0,'jazznut','VelvetVoyager','Jazz historian and vinyl collector.',9,8,'6vWDO969PvNqNYHIOW5v0m','https://i.scdn.co/image/ab6761610000e5eb7eaa373538359164b843f7c0','https://i.scdn.co/image/ab6761610000e5eb7eaa373538359164b843f7c0',40509641,89);
INSERT INTO Profile VALUES(5,1750857439763,1750857544784,5,0,'techsavvy','SynthArchitect','Machine learning engineer and data enthusiast.',12,11,'47T694aNABbLrqSh4Di7Xj','https://i.scdn.co/image/ab6761610000e5ebb75a1151e8c56b47b3b53a4c','https://i.scdn.co/image/ab6761610000e5ebb75a1151e8c56b47b3b53a4c',13225,38);
INSERT INTO Profile VALUES(6,1750857440001,1750857545223,6,0,'artsy_daisy','CanvasFiend','Illustrator and mixed-media artist.',14,13,'7xu08SujAqLp7BGinS96vd','https://i.scdn.co/image/ab6761610000e5ebf4ff959efa8230a9d8f884c6','https://i.scdn.co/image/ab6761610000e5ebf4ff959efa8230a9d8f884c6',151147,50);
INSERT INTO Profile VALUES(7,1750857440236,1750857545756,7,0,'historybuff','RetroShock','Researcher of medieval European history.',16,15,'1QgQF1oyo7at7bSwEeO7YX','https://i.scdn.co/image/ab6761610000e5eb1837bc54352575eff6f155bd','https://i.scdn.co/image/ab6761610000e5eb1837bc54352575eff6f155bd',2260,28);
INSERT INTO Profile VALUES(8,1750857440471,1750857546317,8,0,'biophile','BioFader','Studying biodiversity and conservation.',19,18,'6vcowFkyN7H2X5yTu0nk0G','https://i.scdn.co/image/ab6761610000e5eb67f1ef2914db24000a64ba9b','https://i.scdn.co/image/ab6761610000e5eb67f1ef2914db24000a64ba9b',793,21);
INSERT INTO Profile VALUES(9,1750857448309,1750857448309,9,0,'kevin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO Profile VALUES(10,1750857648324,1750857648324,10,0,'kevinn',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO Profile VALUES(11,1750858008682,1750882300471,11,0,'globuli94','Bruno Mars','Hi im Bruno.',NULL,NULL,'2hdUuoqJUD7RXiGBNhEeUL','https://i.scdn.co/image/ab6761610000e5eb45d3951da001ecce58fcae8f','https://i.scdn.co/image/ab6761610000e5eb45d3951da001ecce58fcae8f',980,47);
INSERT INTO Profile VALUES(12,1750865404125,1750865404125,12,0,'kevin1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO Profile VALUES(13,1750869672846,1750869672846,13,0,'Arutepsu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO Profile VALUES(14,1750869678802,1750869678802,14,0,'Arutepsu2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO Profile VALUES(15,1750871916498,1750874111228,15,0,'malive','Malik Johnson','Hi I am Malik! I recently moved to Germany!',24,23,'5U1eJDpMKZiQustw16e0g2','https://i.scdn.co/image/ab6761610000e5ebf31787d4edcd623863d0c0d3','https://i.scdn.co/image/ab6761610000e5ebf31787d4edcd623863d0c0d3',15225,51);
INSERT INTO Profile VALUES(16,1750875020222,1750878279674,16,0,'testuser1','Kevin','Hi I am Kevin!',NULL,NULL,'2hdUuoqJUD7RXiGBNhEeUL','https://i.scdn.co/image/ab6761610000e5eb45d3951da001ecce58fcae8f','https://i.scdn.co/image/ab6761610000e5eb45d3951da001ecce58fcae8f',980,47);
INSERT INTO Profile VALUES(17,1750882550047,1750883098331,17,0,'testinguser123','Testing User','Hi!',NULL,NULL,'6g6oatdhgEpgVLuIZrF2HR','https://i.scdn.co/image/ab6761610000e5eb7d85412b70fe9815127a575a','https://i.scdn.co/image/ab6761610000e5eb7d85412b70fe9815127a575a',314,23);
CREATE TABLE IF NOT EXISTS "Swipe" (
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "swiperId" INTEGER NOT NULL,
    "swipeeId" INTEGER NOT NULL,

    PRIMARY KEY ("swiperId", "swipeeId"),
    CONSTRAINT "Swipe_swiperId_fkey" FOREIGN KEY ("swiperId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Swipe_swipeeId_fkey" FOREIGN KEY ("swipeeId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO Swipe VALUES(1750863107137,'NEGATIVE',9,11);
INSERT INTO Swipe VALUES(1750866983046,'NEGATIVE',11,1);
INSERT INTO Swipe VALUES(1750866983830,'NEGATIVE',11,2);
INSERT INTO Swipe VALUES(1750866984948,'NEGATIVE',11,3);
INSERT INTO Swipe VALUES(1750866989204,'POSITIVE',11,4);
INSERT INTO Swipe VALUES(1750866990292,'NEGATIVE',11,5);
INSERT INTO Swipe VALUES(1750867386902,'NEGATIVE',11,6);
INSERT INTO Swipe VALUES(1750870333881,'POSITIVE',14,1);
INSERT INTO Swipe VALUES(1750870334709,'NEGATIVE',14,2);
INSERT INTO Swipe VALUES(1750870335527,'POSITIVE',14,3);
INSERT INTO Swipe VALUES(1750870336268,'NEGATIVE',14,4);
INSERT INTO Swipe VALUES(1750870701315,'POSITIVE',14,5);
INSERT INTO Swipe VALUES(1750870702730,'POSITIVE',14,6);
INSERT INTO Swipe VALUES(1750870703338,'POSITIVE',14,7);
INSERT INTO Swipe VALUES(1750870704022,'NEGATIVE',14,8);
INSERT INTO Swipe VALUES(1750871841865,'POSITIVE',12,1);
INSERT INTO Swipe VALUES(1750874510641,'POSITIVE',12,2);
INSERT INTO Swipe VALUES(1750874511431,'POSITIVE',12,3);
INSERT INTO Swipe VALUES(1750874512936,'POSITIVE',12,4);
INSERT INTO Swipe VALUES(1750874513935,'POSITIVE',12,5);
INSERT INTO Swipe VALUES(1750874518459,'POSITIVE',12,6);
INSERT INTO Swipe VALUES(1750874529759,'POSITIVE',12,7);
INSERT INTO Swipe VALUES(1750874530914,'POSITIVE',12,8);
INSERT INTO Swipe VALUES(1750874532807,'POSITIVE',12,15);
INSERT INTO Swipe VALUES(1750876293721,'POSITIVE',16,15);
INSERT INTO Swipe VALUES(1750880300113,'POSITIVE',14,11);
INSERT INTO Swipe VALUES(1750880317174,'NEGATIVE',14,15);
INSERT INTO Swipe VALUES(1750882652283,'NEGATIVE',17,15);
CREATE TABLE IF NOT EXISTS "MusicDisplay" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updateAt" DATETIME NOT NULL,
    "service" TEXT NOT NULL,
    "tackId" TEXT NOT NULL,
    "profileId" INTEGER NOT NULL,
    CONSTRAINT "MusicDisplay_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profile" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE IF NOT EXISTS "Notification" (
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
INSERT INTO Notification VALUES(36,1750875671630,'Kevin has requested to join your session',NULL,0,'SESSION_REQUESTED',7,16,15);
INSERT INTO Notification VALUES(37,1750875690127,'Malik Johnson has requested to join your session',NULL,0,'SESSION_REQUESTED',8,15,16);
INSERT INTO Notification VALUES(38,1750876162297,'Kevin has accepted your request.',NULL,0,'SESSION_REQUEST_ACCEPTED',8,16,15);
INSERT INTO Notification VALUES(39,1750876293726,'Kevin liked your profile.',NULL,0,'LIKED',NULL,16,15);
INSERT INTO Notification VALUES(40,1750880300115,'Arutepsu2 liked your profile.',NULL,0,'LIKED',NULL,14,11);
INSERT INTO Notification VALUES(41,1750880317178,'Arutepsu2 disliked your profile!',NULL,0,'DISLIKED',NULL,14,15);
INSERT INTO Notification VALUES(42,1750882598925,'Malik Johnson has requested to join your session',NULL,0,'SESSION_REQUESTED',9,15,17);
INSERT INTO Notification VALUES(43,1750882644338,'testinguser123 has rejected your request.',NULL,0,'SESSION_REQUEST_REJECTED',9,17,15);
INSERT INTO Notification VALUES(44,1750882652285,'testinguser123 disliked your profile!',NULL,0,'DISLIKED',NULL,17,15);
INSERT INTO Notification VALUES(45,1750882747258,'kevin pinged you',NULL,0,'PING',NULL,9,15);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('AuthSession',33);
INSERT INTO sqlite_sequence VALUES('LPSession',9);
INSERT INTO sqlite_sequence VALUES('Profile',17);
INSERT INTO sqlite_sequence VALUES('MusicDisplay',0);
INSERT INTO sqlite_sequence VALUES('Notification',45);
INSERT INTO sqlite_sequence VALUES('User',17);
INSERT INTO sqlite_sequence VALUES('MapPresence',27);
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
CREATE UNIQUE INDEX "AuthSession_secureId_key" ON "AuthSession"("secureId");
CREATE UNIQUE INDEX "Profile_ownerId_profileOwnerIndex_key" ON "Profile"("ownerId", "profileOwnerIndex");
CREATE UNIQUE INDEX "MusicDisplay_profileId_key" ON "MusicDisplay"("profileId");
COMMIT;