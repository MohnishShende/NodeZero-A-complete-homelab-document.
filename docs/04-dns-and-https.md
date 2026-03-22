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

~~~conf
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
~~~

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

### Global Caddy Configuration

~~~caddy
{
 servers {
  protocols h1 h2
 }
}
~~~

### Virtual Host Map

- `dashboard.home.arpa` → `127.0.0.1:7575`
- `sonarr.home.arpa` → `127.0.0.1:8989`
- `radarr.home.arpa` → `127.0.0.1:7878`
- `prowlarr.home.arpa` → `127.0.0.1:9696`
- `jellyseerr.home.arpa` → `127.0.0.1:5056`
- `jellyfin.home.arpa` → `127.0.0.1:8096`
- `qbittorrent.home.arpa` → `127.0.0.1:8080`
- `pihole.home.arpa` → `127.0.0.1:3000`
- `flaresolverr.home.arpa` → `127.0.0.1:8191`
- `uptime.home.arpa` → `127.0.0.1:3002`

All sites use `tls internal`.

### Internal CA Trust Notes

Because the configuration uses `tls internal`, client devices must trust Caddy’s internal CA.
