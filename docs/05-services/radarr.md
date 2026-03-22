# Radarr

## Image

`linuxserver/radarr`

## Purpose

Radarr handles movie automation, import, and organization. It monitors for wanted movies, sends download jobs to qBittorrent via Prowlarr-managed indexers, and imports completed files into the movies library.

## Ports

| Host | Container |
|------|-----------|
| 7878 | 7878 |

Accessible via: `https://radarr.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `PUID` | `911` |
| `PGID` | `911` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/radarr/config` | `/config` |
| `/mnt/hdd/downloads` | `/downloads` |
| `/mnt/hdd/movies` | `/movies` |

## Notes

- Uses `PUID=911`/`PGID=911` — ownership of `/home/nodezero/radarr` must be `911:911`
- Shares the `/downloads` path with qBittorrent and Sonarr for hardlink-based imports
- Expected response: `HTTP 401` (authentication required)
