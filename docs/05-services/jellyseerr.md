# Jellyseerr

## Image

`fallenbagel/jellyseerr`

## Purpose

Jellyseerr is the media request interface. Users submit requests for movies and TV shows, and Jellyseerr automatically forwards them to Radarr or Sonarr respectively.

## Ports

| Host | Container |
|------|-----------|
| 5056 | 5055 |

Accessible via: `https://jellyseerr.home.arpa`

**Important:** The host port (`5056`) does not match the container port (`5055`). This mapping must be preserved exactly in any rebuild. The Caddyfile proxies to `127.0.0.1:5056` (the host-exposed port).

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/jellyseerr/config` | `/app/config` |

## Notes

- Integrates with Jellyfin for authentication and library sync
- Integrates with Sonarr for TV show requests
- Integrates with Radarr for movie requests
- Expected response: `HTTP 307` redirect to login page
