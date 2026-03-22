# Uptime Kuma

## Image

`louislam/uptime-kuma`

## Purpose

Uptime Kuma provides local service monitoring and endpoint validation for all homelab services. It monitors the `*.home.arpa` endpoints and reports their availability.

## Ports

| Host | Container |
|------|-----------|
| 3002 | 3001 |

Accessible via: `https://uptime.home.arpa`

## Environment

| Variable | Value |
|----------|-------|
| `UPTIME_KUMA_IS_CONTAINER` | `1` |

## DNS Override

The container uses a custom DNS server:

```yaml
dns:
  - 192.168.1.181
```

This is required so the container can resolve internal `home.arpa` hostnames against the host's Pi-hole/Unbound DNS stack when checking service endpoints.

## Bind Mounts

| Host path | Container path |
|-----------|----------------|
| `/home/nodezero/uptime` | `/app/data` |

## Health State

Reported as `healthy` in live system. Health check is built into the container image.
