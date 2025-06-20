# How to run

1. Install Bun https://bun.sh/
2. Copy `.envdevelopment` -> `.env` to create all environment variables
3. Run `bun install` in this directory to install all dependencies
4. Run `bunx prisma db push` to create the database and required generated files.
5. Run `bun run ./src/main.ts` to start the server
6. The API Documentation is hosted on `localhost:3030/swagger`

- Run `bunx prisma db push` everytime you pull new changes