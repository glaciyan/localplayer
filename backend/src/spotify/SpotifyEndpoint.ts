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

interface SpotifyTokenResponse {
    access_token: string;
    token_type: string;
    expires_in: number; // seconds until expiration
}

export class SpotifyTokenManager {
    private clientId: string;
    private clientSecret: string;
    private accessToken: string | null = null;
    private expiresAt: number = 0; // timestamp in ms

    constructor(clientId: string, clientSecret: string) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
    }

    /**
     * Returns a valid access token, refreshing it if expired or missing.
     */
    public async getAccessToken(): Promise<string> {
        const now = Date.now();

        if (!this.accessToken || now >= this.expiresAt) {
            await this.requestNewToken();
        }

        return this.accessToken!;
    }

    /**
     * Performs the client‐credentials request to Spotify and updates internal state.
     */
    private async requestNewToken(): Promise<void> {
        const creds = Buffer.from(
            `${this.clientId}:${this.clientSecret}`
        ).toString("base64");
        const response = await fetch("https://accounts.spotify.com/api/token", {
            method: "POST",
            headers: {
                Authorization: `Basic ${creds}`,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: new URLSearchParams({ grant_type: "client_credentials" }),
        });

        if (!response.ok) {
            throw new Error(
                `Spotify token request failed (${response.status}): ${response.statusText}`
            );
        }

        const data: SpotifyTokenResponse = await response.json();
        this.accessToken = data.access_token;
        // Set expiration a little earlier than actual expiry to account for clock skew
        this.expiresAt = Date.now() + (data.expires_in - 60) * 1000;
    }
}

const clientId = process.env["SPOTIFY_CLIENT_ID"];
const secret = process.env["SPOTIFY_CLIENT_SECRET"];

if (!clientId || !secret) {
    log.error("No spotify credentials set. Set the SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET env variables.");
    throw "No spotify credentials set";
}

export const spotify = new SpotifyTokenManager(clientId, secret);