# Services Overview

This directory contains individual service documentation.

## Services

| Service | Image | Port | Purpose |
|---------|-------|------|---------|
| [Homarr](homarr.md) | `ghcr.io/homarr-labs/homarr:latest` | 7575 | Dashboard |
| [Uptime Kuma](uptime-kuma.md) | `louislam/uptime-kuma` | 3002 | Monitoring |
| [FlareSolverr](flaresolverr.md) | `ghcr.io/flaresolverr/flaresolverr:latest` | 8191 | Anti-bot proxy |
| [qBittorrent](qbittorrent.md) | `lscr.io/linuxserver/qbittorrent` | 8080 | Downloader |
| [Jellyfin](jellyfin.md) | `jellyfin/jellyfin` | 8096 | Media server |
| [Jellyseerr](jellyseerr.md) | `fallenbagel/jellyseerr` | 5056 | Media requests |
| [Prowlarr](prowlarr.md) | `linuxserver/prowlarr` | 9696 | Indexer manager |
| [Radarr](radarr.md) | `linuxserver/radarr` | 7878 | Movie automation |
| [Sonarr](sonarr.md) | `linuxserver/sonarr` | 8989 | TV automation |

Each file describes image, purpose, ports, volumes, environment, and notes.

## Media Pipeline Architecture

The full media automation pipeline flows as follows:

```
User
 └─► Jellyseerr (requests)
       ├─► Sonarr (TV shows)
       │     ├─► Prowlarr (indexers)
       │     └─► qBittorrent (downloads) ──► /mnt/hdd/downloads
       │                                           └─► /mnt/hdd/tv (imported)
       └─► Radarr (movies)
             ├─► Prowlarr (indexers)
             └─► qBittorrent (downloads) ──► /mnt/hdd/downloads
                                                   └─► /mnt/hdd/movies (imported)

Jellyfin ◄── /mnt/hdd (as /media)
```

Step by step:

1. User submits a request in Jellyseerr
2. Jellyseerr forwards to Sonarr (TV) or Radarr (movies)
3. Sonarr/Radarr query Prowlarr-managed indexers
4. Download jobs are sent to qBittorrent
5. qBittorrent writes completed downloads to `/mnt/hdd/downloads`
6. Sonarr or Radarr imports and organizes media into `/mnt/hdd/tv` or `/mnt/hdd/movies`
7. Jellyfin serves all libraries from `/mnt/hdd` mounted as `/media`

FlareSolverr provides anti-bot bypass support for indexers that require Cloudflare challenge solving.

### Container Path Consistency

| Container | Internal path | Host path |
|-----------|--------------|-----------|
| qBittorrent | `/downloads` | `/mnt/hdd/downloads` |
| Sonarr | `/downloads` | `/mnt/hdd/downloads` |
| Sonarr | `/tv` | `/mnt/hdd/tv` |
| Radarr | `/downloads` | `/mnt/hdd/downloads` |
| Radarr | `/movies` | `/mnt/hdd/movies` |
| Jellyfin | `/media` | `/mnt/hdd` |

All *arr containers and qBittorrent share the same download directory path. This is required for hardlink-based imports to work correctly.
