# Architecture

## Hardware and Host Platform

Runtime facts documented in the report:

- Architecture: `x86_64`
- CPU count visible to Docker: `4`
- Total RAM visible to Docker: `7.644 GiB`
- Kernel: `Linux 6.17.0-19-generic`

Known baseline platform characteristics:

- System class: Acer Veriton X6640G class host
- CPU family: Intel Core i5-6500TE class
- RAM class: 8 GB DDR4
- Network class: Gigabit Ethernet

## Operating System and Base Environment

- Distribution family: Ubuntu
- Release family: Ubuntu 25.10
- Kernel: `6.17.0-19-generic`
- Shell: `/bin/bash`
- Primary user: `nodezero`

## Docker Packaging Model

The live installation uses Snap-packaged Docker, not the standard apt-based Docker install.

Documented indicators:

- Docker root dir: `/var/snap/docker/common/var-lib-docker`
- Active Docker service: `snap.docker.dockerd.service`

Versions recorded in the report:

- Docker Engine: `28.4.0`
- Docker Compose plugin: `v2.39.1`
- Buildx: `v0.24.0`
- containerd: `v1.7.27`
- runc: `1.2.6`
- Cgroup version: `2`
- Storage driver: `overlay2`

## Filesystems, Mounts, and Persistence

Observed key filesystems include:

- EFI partition mounted at `/boot/efi`
- Data disk mounted at `/mnt/hdd`

Critical storage facts:

- EFI partition: `/dev/sda1`, `1.1G`, mounted at `/boot/efi`
- Data disk: `/dev/sdc1`, `916G`, mounted at `/mnt/hdd`
- Data disk usage: `632G used`, `238G available`, `73% utilized`

## fstab

~~~fstab
/dev/disk/by-uuid/147f22a2-1432-419a-82be-f0d12bd9378a / ext4 defaults 0 1
/dev/disk/by-uuid/0DCA-96B4 /boot/efi vfat defaults 0 1
/swap.img none swap sw 0 0
UUID=34f174a0-9d97-49d1-9d07-16799356b269 /mnt/hdd ext4 defaults,nofail 0 2
~~~

## Persistence Model

### Host configuration and app state

Stored under `/home/nodezero/...`, including:

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

### Media and downloads

Stored under `/mnt/hdd/...`, including:

- `/mnt/hdd/downloads`
- `/mnt/hdd/movies`
- `/mnt/hdd/tv`

## Critical Host Paths

These paths are first-class rebuild and backup assets:

- `/home/nodezero/homelab-compose/compose.yaml`
- `/etc/caddy/Caddyfile`
- `/etc/fstab`
- `/etc/unbound/unbound.conf`
- `/etc/unbound/unbound.conf.d/pi-hole.conf`
- `/etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf`
- `/etc/unbound/unbound.conf.d/remote-control.conf`
- `/etc/samba/smb.conf`
- `/etc/pihole`
- `/etc/dnsmasq.d`
