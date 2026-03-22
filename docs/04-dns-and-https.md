# DNS and HTTPS

## DNS Architecture

### Resolver State

Current `/etc/resolv.conf` as captured in the report:

~~~conf
nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 8.8.8.8
nameserver 127.0.0.1
search .
~~~

### systemd-resolved State

Relevant resolver state:

- Global DNS servers: `127.0.0.1 127.0.0.1`
- `resolv.conf` mode: `uplink`
- `eno1` DNS servers: `1.1.1.1 8.8.8.8 127.0.0.1`
- DNS domain: `~.`

Interpretation:

- the host prefers a mixed resolver model
- loopback DNS is active
- public resolvers are also configured at the link layer
- this is functional, but not a strictly loopback-only DNS path

### Pi-hole Runtime State

Observed runtime facts:

- `pihole-FTL.service` is running
- UDP port 53 listening on `0.0.0.0`
- UDP port 53 listening on `[::]`
- TCP port 53 listening on `0.0.0.0`
- TCP port 53 listening on `[::]`
- TCP port 3000 listening on `0.0.0.0` and `[::]`

### Pi-hole Notes

Important findings:

- `/etc/pihole/setupVars.conf` was not found
- `/etc/pihole` is clearly present and active
- rebuild documentation should not rely on `setupVars.conf` as a required truth source

### dnsmasq Local Override

Documented local override presence:

- `/etc/dnsmasq.d/02-home-arpa.conf`

Important note:

- the file exists, but its exact content was not captured in the source report

### Unbound Runtime State

Observed runtime facts:

- `unbound.service` is running
- Unbound listens on `127.0.0.1:5335` over both UDP and TCP

## Unbound Configuration

Unbound is configured across four files:

**`/etc/unbound/unbound.conf`** (top-level, includes all drop-ins):

```conf
include-toplevel: "/etc/unbound/unbound.conf.d/*.conf"
```

**`/etc/unbound/unbound.conf.d/pi-hole.conf`** (main server config):

```conf
server:
    verbosity: 1
    interface: 127.0.0.1
    port: 5335
    do-ip4: yes
    do-udp: yes
    do-tcp: yes
    access-control: 127.0.0.0/8 allow
    root-hints: "/var/lib/unbound/root.hints"
    hide-identity: yes
    hide-version: yes
    harden-glue: yes
    harden-dnssec-stripped: yes
    use-caps-for-id: yes
    edns-buffer-size: 1232
    prefetch: yes
    num-threads: 2
```

**`/etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf`** (DNSSEC):

```conf
server:
    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

**`/etc/unbound/unbound.conf.d/remote-control.conf`** (control socket):

```conf
remote-control:
  control-enable: yes
  control-interface: /run/unbound.ctl
```

All four files must be created on rebuild. See `dns/unbound/unbound.conf` in this repository for the combined reference.

## Practical DNS Flow

1. Client queries Pi-hole
2. Pi-hole resolves local domains or forwards external lookups
3. Unbound performs recursive external resolution
4. Result returns through Pi-hole to the client

## Reverse Proxy and Internal HTTPS

### Caddy Runtime State

Observed runtime facts:

- `caddy.service` is running
- Caddy listens on port `80`
- Caddy listens on port `443`
- Caddy admin endpoint listens on `127.0.0.1:2019`

### Full Caddyfile

The live `/etc/caddy/Caddyfile` (also stored at `caddy/Caddyfile` in this repo):

```caddy
{
        servers {
                protocols h1 h2
        }
}

dashboard.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:7575
}

sonarr.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:8989
}

radarr.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:7878
}

prowlarr.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:9696
}

jellyseerr.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:5056
}

jellyfin.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:8096
}

qbittorrent.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:8080
}

pihole.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:3000
}

flaresolverr.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:8191
}

uptime.home.arpa {
        tls internal
        reverse_proxy 127.0.0.1:3002
}
```

Note: `jellyseerr.home.arpa` proxies to port `5056` because the container exposes `5056:5055` (non-matching mapping).

### Virtual Host Map

| Hostname | Upstream | Service |
|----------|----------|---------|
| `dashboard.home.arpa` | `127.0.0.1:7575` | Homarr |
| `sonarr.home.arpa` | `127.0.0.1:8989` | Sonarr |
| `radarr.home.arpa` | `127.0.0.1:7878` | Radarr |
| `prowlarr.home.arpa` | `127.0.0.1:9696` | Prowlarr |
| `jellyseerr.home.arpa` | `127.0.0.1:5056` | Jellyseerr |
| `jellyfin.home.arpa` | `127.0.0.1:8096` | Jellyfin |
| `qbittorrent.home.arpa` | `127.0.0.1:8080` | qBittorrent |
| `pihole.home.arpa` | `127.0.0.1:3000` | Pi-hole admin |
| `flaresolverr.home.arpa` | `127.0.0.1:8191` | FlareSolverr |
| `uptime.home.arpa` | `127.0.0.1:3002` | Uptime Kuma |

All sites use `tls internal`.

### Verified HTTP Response Behavior

| Hostname | Response | Meaning |
|----------|----------|---------|
| `dashboard.home.arpa` | HTTP 200 | Dashboard reachable |
| `uptime.home.arpa` | HTTP 302 | Redirect correct |
| `sonarr.home.arpa` | HTTP 401 | Auth gate functioning |
| `radarr.home.arpa` | HTTP 401 | Auth gate functioning |
| `prowlarr.home.arpa` | HTTP 401 | Auth gate functioning |
| `jellyfin.home.arpa` | HTTP 302 | Redirect to web UI |
| `jellyseerr.home.arpa` | HTTP 307 | Redirect to login |
| `qbittorrent.home.arpa` | HTTP 200 | UI reachable |
| `flaresolverr.home.arpa` | HTTP 200 | API reachable |

### Internal CA Trust Notes

Because the configuration uses `tls internal`, client devices must trust Caddy’s internal CA. Install the Caddy root CA certificate on any device that needs to access `*.home.arpa` without browser warnings.

## Important Notes

- DNS currently mixes loopback and public resolvers
- ideal configuration should prefer loopback-only resolution
- `02-home-arpa.conf` is required for internal domain resolution but was not captured

This file must be backed up or recreated manually.
