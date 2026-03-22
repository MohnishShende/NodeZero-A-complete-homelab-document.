# FlareSolverr

## Image

`ghcr.io/flaresolverr/flaresolverr:latest`

## Purpose

FlareSolverr provides anti-bot bypass support for indexers that require solving Cloudflare challenges. Prowlarr routes requests through FlareSolverr when a configured indexer is behind Cloudflare protection.

## Ports

| Host | Container |
|------|-----------|
| 8191 | 8191 |

Accessible via: `https://flaresolverr.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `LOG_LEVEL` | `info` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/flaresolverr` | `/config` |

## Notes

- FlareSolverr does not require direct user interaction
- It is configured as a proxy in Prowlarr settings using `http://192.168.1.181:8191`
- Expected response when accessed directly: `HTTP 200` with JSON status output
