# Backups

## What Must Be Backed Up

### Host-Level Configuration

- `/etc/caddy/Caddyfile`
- `/etc/fstab`
- `/etc/unbound/unbound.conf`
- `/etc/unbound/unbound.conf.d/`
- `/etc/samba/smb.conf`
- `/etc/pihole/`
- `/etc/dnsmasq.d/`

### Compose Deployment Definition

- `/home/nodezero/homelab-compose/compose.yaml`

### Application State

- `/home/nodezero/homarr/appdata`
- `/home/nodezero/uptime`
- `/home/nodezero/flaresolverr`
- `/home/nodezero/qbittorrent/config`
- `/home/nodezero/jellyfin/cache`
- `/home/nodezero/jellyfin/config`
- `/home/nodezero/jellyseerr/config`
- `/home/nodezero/prowlarr/config`
- `/home/nodezero/radarr/config`
- `/home/nodezero/sonarr/config`

### Media Content

- `/mnt/hdd/downloads`
- `/mnt/hdd/movies`
- `/mnt/hdd/tv`

## Example Backup Commands

~~~bash
tar -czvf /mnt/hdd/homelab-config-backup-$(date +%F).tar.gz \
 /home/nodezero \
 /etc/caddy \
 /etc/fstab \
 /etc/unbound \
 /etc/samba \
 /etc/pihole \
 /etc/dnsmasq.d

tar -czvf /mnt/hdd/homelab-media-backup-$(date +%F).tar.gz \
 /mnt/hdd/downloads \
 /mnt/hdd/movies \
 /mnt/hdd/tv
~~~

## Recovery Order

1. Base OS
2. data disk mount
3. Docker
4. Caddy
5. Pi-hole and Unbound
6. Tailscale
7. Samba
8. `/home/nodezero` app state
9. `/mnt/hdd` media state
10. Compose deployment
11. validation checks
