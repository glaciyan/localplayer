import { Elysia, t, status } from "elysia";
import { AuthService } from "../authentication/AuthService.ts";
import { mklog } from "../logger.ts";

const log = mklog("spotify");

log.info("Starting up Spotify Service");

export const SpotifyEndpoint = new Elysia({ prefix: "/spotify" })
    .use(AuthService)
    .get(
        "/preview",
        async ({ query: { trackId } }) => {
            try {
                // https://stackoverflow.com/a/79238027
                log.info(`Trying to fetch preview for ${trackId}`);
                const response = await fetch(
                    `https://open.spotify.com/embed/track/${trackId}`
                );
                const htmlPage = await response.text();

                const matches = htmlPage.match(
                    /"audioPreview":\s*{\s*"url":\s*"([^"]+)"/
                );
                const mp3Url = matches ? matches[1] : null;

                if (!mp3Url) {
                    log.error(`Could not find mp3 for song ${trackId}`);
                    return status(404);
                }

                log.info(`Found mp3 url ${mp3Url} for song ${trackId}`);

                const song = await fetch(mp3Url);
                return await song.arrayBuffer();
            } catch (error) {
                log.error(
                    `Failed to fetch spotify song preview for ${trackId}`
                );
                return status(404);
            }
        },
        {
            cookie: "session",
            requireProfile: true,
            query: t.Object({
                trackId: t.String(),
            }),
            detail: {
                description:
                    "Fetch a song preview mp3 from a spotify track ID.",
            },
        }
    );
