# Homarr

## Image

`ghcr.io/homarr-labs/homarr:latest`

## Purpose

Homarr is the main dashboard and front door for the homelab. It provides a centralized access surface for all services and integrates with Docker through the mounted socket to display container status.

## Ports

| Host | Container |
|------|-----------|
| 7575 | 7575 |

Accessible via: `https://dashboard.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `SECRET_ENCRYPTION_KEY` | Set in `.env` |
| `DB_URL` | `/appdata/db/db.sqlite` |
| `DB_DIALECT` | `sqlite` |
| `DB_DRIVER` | `better-sqlite3` |
| `AUTH_PROVIDERS` | `credentials` |
| `REDIS_IS_EXTERNAL` | `false` |
| `NODE_ENV` | `production` |

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/homarr/appdata` | `/appdata` |
| `/var/run/docker.sock` | `/var/run/docker.sock` |

## Security Note

This service mounts `/var/run/docker.sock`, which grants root-level access to the host Docker daemon. This is required for container status widgets but is a high-privilege configuration. Do not expose this service externally.
