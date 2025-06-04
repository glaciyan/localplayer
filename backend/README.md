# How to run

1. Install Bun https://bun.sh/
2. Copy `.env.development` -> `.env` to create all environment variables
3. Run `bun install` in this directory to install all dependencies
4. Run `bunx prisma db push` to create the database and required generated files
5. Run `bun run ./src/main.ts` to start the server
