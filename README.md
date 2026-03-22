# HOMELAB MASTER DOCUMENTATION
## NodeZero Infrastructure Report, Final Verbatim-Aligned Reference
### Version v4.1
### Date: 22 March 2026
### Owner: Mohnish Shende

---

## Table of Contents

- [1. Document Purpose](#1-document-purpose)
- [2. Scope and Truth Model](#2-scope-and-truth-model)
- [3. Executive Summary](#3-executive-summary)
- [4. System Identity](#4-system-identity)
- [5. Current Operational Status](#5-current-operational-status)
- [6. Hardware and Host Platform](#6-hardware-and-host-platform)
- [7. Operating System and Base Environment](#7-operating-system-and-base-environment)
- [8. Filesystems, Mounts, and Persistence](#8-filesystems-mounts-and-persistence)
  - [8.1 Current Mounted Filesystems](#81-current-mounted-filesystems)
  - [8.2 fstab Configuration](#82-fstab-configuration)
  - [8.3 Persistence Model](#83-persistence-model)
  - [8.4 Critical Host Paths](#84-critical-host-paths)
- [9. Network Topology](#9-network-topology)
  - [9.1 Interface Inventory](#91-interface-inventory)
  - [9.2 IP Addressing](#92-ip-addressing)
  - [9.3 Routing Table](#93-routing-table)
  - [9.4 Logical Traffic Flow](#94-logical-traffic-flow)
- [10. DNS Architecture](#10-dns-architecture)
  - [10.1 Resolver State](#101-resolver-state)
  - [10.2 systemd-resolved State](#102-systemd-resolved-state)
  - [10.3 Pi-hole Runtime State](#103-pi-hole-runtime-state)
  - [10.4 Pi-hole Local Config Notes](#104-pi-hole-local-config-notes)
  - [10.5 dnsmasq Local Override](#105-dnsmasq-local-override)
  - [10.6 Unbound Runtime State](#106-unbound-runtime-state)
  - [10.7 Verbatim Unbound Configuration](#107-verbatim-unbound-configuration)
  - [10.8 Practical DNS Flow](#108-practical-dns-flow)
  - [10.9 DNS Caveats](#109-dns-caveats)
- [11. Reverse Proxy and Internal HTTPS](#11-reverse-proxy-and-internal-https)
  - [11.1 Caddy Runtime State](#111-caddy-runtime-state)
  - [11.2 Caddy Global Configuration](#112-caddy-global-configuration)
  - [11.3 Virtual Host Map](#113-virtual-host-map)
  - [11.4 Verified HTTP Response Behavior](#114-verified-http-response-behavior)
  - [11.5 Internal CA Trust Notes](#115-internal-ca-trust-notes)
- [12. Docker Platform](#12-docker-platform)
  - [12.1 Docker Runtime State](#121-docker-runtime-state)
  - [12.2 Docker Packaging Model](#122-docker-packaging-model)
  - [12.3 Compose Project State](#123-compose-project-state)
  - [12.4 Docker Networking](#124-docker-networking)
  - [12.5 Docker Storage Model](#125-docker-storage-model)
- [13. Full Application Inventory](#13-full-application-inventory)
  - [13.1 Homarr](#131-homarr)
  - [13.2 Uptime Kuma](#132-uptime-kuma)
  - [13.3 FlareSolverr](#133-flaresolverr)
  - [13.4 qBittorrent](#134-qbittorrent)
  - [13.5 Jellyfin](#135-jellyfin)
  - [13.6 Jellyseerr](#136-jellyseerr)
  - [13.7 Prowlarr](#137-prowlarr)
  - [13.8 Radarr](#138-radarr)
  - [13.9 Sonarr](#139-sonarr)
- [14. Full Compose Configuration](#14-full-compose-configuration)
- [15. Port Exposure Inventory](#15-port-exposure-inventory)
  - [15.1 Container and Proxy Ports](#151-container-and-proxy-ports)
  - [15.2 Host Service Ports](#152-host-service-ports)
  - [15.3 Other Observed Listening Services](#153-other-observed-listening-services)
- [16. Service and Process Inventory](#16-service-and-process-inventory)
- [17. Samba Configuration](#17-samba-configuration)
- [18. Security Model](#18-security-model)
  - [18.1 Positive Security Properties](#181-positive-security-properties)
  - [18.2 Observed Security Gaps and Tradeoffs](#182-observed-security-gaps-and-tradeoffs)
- [19. Media Pipeline Architecture](#19-media-pipeline-architecture)
- [20. Permissions and Ownership Model](#20-permissions-and-ownership-model)
- [21. Operational Workflows](#21-operational-workflows)
  - [21.1 Standard Compose Lifecycle Commands](#211-standard-compose-lifecycle-commands)
  - [21.2 Validation Commands](#212-validation-commands)
  - [21.3 Update Workflow](#213-update-workflow)
  - [21.4 Post-Change Validation Checklist](#214-post-change-validation-checklist)
- [22. Rebuild From Zero Procedure](#22-rebuild-from-zero-procedure)
  - [22.1 Hardware and Base OS](#221-hardware-and-base-os)
  - [22.2 Initial Host Preparation](#222-initial-host-preparation)
  - [22.3 Create Persistent Directory Layout](#223-create-persistent-directory-layout)
  - [22.4 Configure Data Mount](#224-configure-data-mount)
  - [22.5 Install Docker and Compose](#225-install-docker-and-compose)
  - [22.6 Install and Configure Caddy](#226-install-and-configure-caddy)
  - [22.7 Install and Configure Pi-hole and Unbound](#227-install-and-configure-pi-hole-and-unbound)
  - [22.8 Install and Configure Tailscale](#228-install-and-configure-tailscale)
  - [22.9 Install and Configure Samba](#229-install-and-configure-samba)
  - [22.10 Deploy Compose Stack](#2210-deploy-compose-stack)
  - [22.11 Validate Rebuild](#2211-validate-rebuild)
- [23. Backup and Recovery Recommendations](#23-backup-and-recovery-recommendations)
  - [23.1 What Must Be Backed Up](#231-what-must-be-backed-up)
  - [23.2 Example Backup Commands](#232-example-backup-commands)
  - [23.3 Recovery Order](#233-recovery-order)
- [24. Known Constraints and Notes](#24-known-constraints-and-notes)
- [25. Final Assessment](#25-final-assessment)
- [Appendix A. Current Compose YAML](#appendix-a-current-compose-yaml)
- [Appendix B. Current Caddyfile](#appendix-b-current-caddyfile)
- [Appendix C. Current fstab](#appendix-c-current-fstab)
- [Appendix D. Verbatim Unbound Files](#appendix-d-verbatim-unbound-files)
- [Appendix E. Verbatim Samba Configuration](#appendix-e-verbatim-samba-configuration)
- [Appendix F. Verbatim Resolver Output](#appendix-f-verbatim-resolver-output)
- [Appendix G. Verbatim Curl Validation Output](#appendix-g-verbatim-curl-validation-output)

---

## 1. Document Purpose

This document is intended to be the final working reference for NodeZero.

It serves four purposes:

1. **Current state documentation**, meaning what is actually running right now.
2. **Disaster recovery reference**, meaning what must be restored to get the homelab back.
3. **Rebuild guide from zero**, meaning the system can be rebuilt from a fresh Ubuntu installation.
4. **Operational handbook**, meaning regular maintenance, updates, validation, and troubleshooting can be performed from this document alone.

This version is stronger than previous drafts because it includes additional verbatim runtime evidence for:

- resolver state
- Pi-hole filesystem presence
- dnsmasq override presence
- Unbound configuration
- Samba configuration
- Docker and Compose runtime
- listening ports
- curl validation output

Where exact files are still not captured, this document says so explicitly instead of pretending otherwise.

---

## 2. Scope and Truth Model

### Verified directly from live terminal output

The following areas were directly verified from runtime data across the session:

- filesystem mounts
- `/etc/fstab`
- `df -h`
- interface addresses
- routes
- `/etc/resolv.conf`
- `resolvectl status`
- Pi-hole directory state
- dnsmasq directory state
- Unbound config files
- Caddyfile
- Samba config
- Docker container state
- Docker network state
- Docker volume state
- Docker info
- Compose file
- Compose resolved config
- running systemd services
- listening ports
- curl reachability and response behavior for all major homelab endpoints

### Verified earlier in the same session

The following were verified earlier and remain valid unless explicitly contradicted:

- current mounted filesystem details for `/mnt/hdd`
- current fstab entries
- full interface list including `tailscale0`, `docker0`, and the Compose bridge
- route table
- data disk utilization
- current active container images and mappings

### Not captured verbatim yet

The following were not captured as exact files or exact live command outputs in the latest successful dump:

- `hostnamectl`
- `/etc/os-release`
- `lsblk -f`
- exact `blkid` output
- exact Tailscale status output
- exact Caddy local CA file paths
- exact ownership and ACL output for every key directory
- exact Pi-hole setup wizard answers
- exact file content of `/etc/dnsmasq.d/02-home-arpa.conf`

These gaps are now relatively small. The infrastructure can already be rebuilt from this document, but a future v4.2 could include those last verbatim details if desired.

---

## 3. Executive Summary

NodeZero is a single-node homelab running Ubuntu 25.10 on x86_64 hardware. It functions as a local-first self-hosted platform for media automation, streaming, monitoring, internal DNS, internal HTTPS, Samba file sharing, and secure remote access.

The application layer is managed through Docker Compose and currently consists of nine active containers:

- Homarr
- Uptime Kuma
- FlareSolverr
- qBittorrent
- Jellyfin
- Jellyseerr
- Prowlarr
- Radarr
- Sonarr

The host layer remains outside containers for core infrastructure services:

- Caddy
- Pi-hole
- Unbound
- Tailscale
- SSH
- Samba
- NetworkManager
- systemd-resolved
- other host services

The current stack is healthy and reproducible. Uptime Kuma and Jellyfin report healthy status. Reverse proxy routing through Caddy works correctly for all documented service endpoints under `home.arpa`. Data persistence is cleanly split between configuration state under `/home/nodezero` and media data under `/mnt/hdd`.

The most important architectural gain in the current state is that the Docker application layer is now reproducible via Compose, rather than being dependent on manual container creation.

---

## 4. System Identity

- **Hostname:** `nodezero`
- **Primary user:** `nodezero`
- **Primary Compose working directory:** `/home/nodezero/homelab-compose`
- **Primary LAN IP:** `192.168.1.181`
- **Primary Tailscale IPv4:** `100.65.240.47`
- **Primary Tailscale IPv6:** `fd7a:115c:a1e0::7b36:f02f`
- **Local internal domain:** `home.arpa`

---

## 5. Current Operational Status

The system is operational and verified.

### Current verified runtime condition

- Docker Engine is running
- Docker Compose project is deployed
- 9 of 9 containers are running
- Jellyfin is healthy
- Uptime Kuma is healthy
- Caddy is running
- Pi-hole FTL is running
- Unbound is running
- Tailscale is running
- SSH is running
- Samba is running
- UFW is inactive
- Media disk is mounted and available at `/mnt/hdd`

### Verified reverse proxy behavior

Recent `curl -kI` checks returned:

- `https://dashboard.home.arpa` → **HTTP 200**
- `https://uptime.home.arpa` → **HTTP 302**
- `https://sonarr.home.arpa` → **HTTP 401**
- `https://radarr.home.arpa` → **HTTP 401**
- `https://prowlarr.home.arpa` → **HTTP 401**
- `https://jellyfin.home.arpa` → **HTTP 302**
- `https://jellyseerr.home.arpa` → **HTTP 307**
- `https://qbittorrent.home.arpa` → **HTTP 200**
- `https://flaresolverr.home.arpa` → **HTTP 200**

These are healthy and expected application responses.

---

## 6. Hardware and Host Platform

From current runtime facts:

- **Architecture:** x86_64
- **CPU count visible to Docker:** 4
- **Total RAM visible to Docker:** 7.644 GiB
- **Kernel:** Linux 6.17.0-19-generic

Known baseline platform characteristics from earlier session context:

- **System class:** Acer Veriton X6640G class host
- **CPU family:** Intel Core i5-6500TE class
- **RAM class:** 8 GB DDR4
- **Network class:** Gigabit Ethernet

The runtime facts and known baseline are consistent.

---

## 7. Operating System and Base Environment

- **Distribution family:** Ubuntu
- **Release family:** Ubuntu 25.10
- **Kernel:** 6.17.0-19-generic
- **Shell:** `/bin/bash`
- **Primary user:** `nodezero`

### Important Docker packaging note

Current Docker info reports:

- **Operating System reported by Docker:** Ubuntu Core 24
- **Docker root dir:** `/var/snap/docker/common/var-lib-docker`

This confirms Docker is running from the **Snap packaging model**, not from a standard apt-managed Docker package.

### Docker versions

- **Docker Engine:** 28.4.0
- **Docker Compose plugin:** v2.39.1
- **Buildx:** v0.24.0
- **containerd:** v1.7.27
- **runc:** 1.2.6
- **Cgroup version:** 2
- **Storage driver:** overlay2

---

## 8. Filesystems, Mounts, and Persistence

### 8.1 Current Mounted Filesystems

Observed key filesystems earlier in the session include:

- `/dev/sda1` mounted at `/boot/efi`
- `/dev/sdc1` mounted at `/mnt/hdd`
- tmpfs mounts for runtime and credentials

### Current critical storage facts

- **EFI partition:** `/dev/sda1`, 1.1G, mounted at `/boot/efi`
- **Data disk:** `/dev/sdc1`, 916G, mounted at `/mnt/hdd`
- **Data disk usage:** 632G used, 238G available, 73% utilized

### 8.2 fstab Configuration

Current `/etc/fstab`:

```fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/147f22a2-1432-419a-82be-f0d12bd9378a / ext4 defaults 0 1
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/0DCA-96B4 /boot/efi vfat defaults 0 1
/swap.img       none    swap    sw      0       0
UUID=34f174a0-9d97-49d1-9d07-16799356b269 /mnt/hdd ext4 defaults,nofail 0 2
```

### 8.3 Persistence Model

The persistence model is strongly defined.

#### Host configuration and app state

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

#### Media and downloads

Stored under `/mnt/hdd/...`, including:

- `/mnt/hdd/downloads`
- `/mnt/hdd/movies`
- `/mnt/hdd/tv`

This provides a clean separation between service state and large media content.

### 8.4 Critical Host Paths

These paths are operationally critical and should be treated as first-class backup and rebuild assets:

- `/home/nodezero/homelab-compose/compose.yaml`
- `/etc/caddy/Caddyfile`
- `/etc/fstab`
- `/etc/unbound/unbound.conf`
- `/etc/unbound/unbound.conf.d/pi-hole.conf`
- `/etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf`
- `/etc/unbound/unbound.conf.d/remote-control.conf`
- `/etc/samba/smb.conf`
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
- `/mnt/hdd/downloads`
- `/mnt/hdd/movies`
- `/mnt/hdd/tv`
- `/etc/pihole`
- `/etc/dnsmasq.d`

---

## 9. Network Topology

### 9.1 Interface Inventory

Current interfaces observed earlier include:

- `lo`
- `eno1`
- `tailscale0`
- `docker0`
- `br-9fc82ac52769`
- multiple `veth*` interfaces attached to the Compose bridge

### 9.2 IP Addressing

#### Loopback

- `127.0.0.1/8`
- `::1/128`

#### Primary LAN interface, `eno1`

- IPv4: `192.168.1.181/24`

#### Tailscale interface, `tailscale0`

- IPv4: `100.65.240.47/32`
- IPv6: `fd7a:115c:a1e0::7b36:f02f/128`

#### Docker default bridge

- `docker0`: `172.17.0.1/16`

#### Compose bridge network

- `br-9fc82ac52769`: `172.18.0.1/16`

### 9.3 Routing Table

Current routes observed earlier:

- Default route via `192.168.1.1` on `eno1`
- `172.17.0.0/16` via `docker0`
- `172.18.0.0/16` via `br-9fc82ac52769`
- `192.168.1.0/24` directly on `eno1`

### 9.4 Logical Traffic Flow

#### Normal LAN service access

Client → Pi-hole DNS → Caddy → application port

#### Internal domain access

Client → resolve `*.home.arpa` to `192.168.1.181` → HTTPS to Caddy → reverse proxy to localhost service

#### Remote access path

Remote device → Tailscale → NodeZero → internal services

---

## 10. DNS Architecture

### 10.1 Resolver State

Current `/etc/resolv.conf` content:

```conf
# This is /run/systemd/resolve/resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
#
# This file might be symlinked as /etc/resolv.conf. If you're looking at
# /etc/resolv.conf and seeing this text, you have followed the symlink.
#
# This is a dynamic resolv.conf file for connecting local clients directly to
# all known uplink DNS servers. This file lists all configured search domains.
#
# Third party programs should typically not access this file directly, but only
# through the symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a
# different way, replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 8.8.8.8
# Too many DNS servers configured, the following entries may be ignored.
nameserver 127.0.0.1
search .
```

### 10.2 systemd-resolved State

Current `resolvectl status` relevant output:

- **Global DNS servers:** `127.0.0.1 127.0.0.1`
- **resolv.conf mode:** `uplink`
- **eno1 DNS servers:** `1.1.1.1 8.8.8.8 127.0.0.1`
- **DNS domain:** `~.`

Interpretation:

- the host prefers a mixed resolver model
- loopback DNS is active
- public resolvers are also configured at the link layer
- this is functional, but not a strictly loopback-only DNS path

### 10.3 Pi-hole Runtime State

Observed runtime facts:

- `pihole-FTL.service` is running
- UDP port 53 is listening on `0.0.0.0`
- UDP port 53 is listening on `[::]`
- TCP port 53 is listening on `0.0.0.0`
- TCP port 53 is listening on `[::]`
- TCP port 3000 is listening on `0.0.0.0` and `[::]`

Current `/etc/pihole` directory exists and contains:

- `adlists.list`
- `cli_pw`
- `config_backups/`
- `dhcp.leases`
- `dnsmasq.conf`
- `gravity.db`
- `gravity_backups/`
- `gravity_old.db`
- `hosts/`
- `install.log`
- `listsCache/`
- `logrotate`
- `macvendor.db`
- `migration_backup/`
- `migration_backup_v6/`
- `pihole-FTL.conf`
- `pihole-FTL.db`
- `pihole.toml`
- `tls.crt`
- `tls.pem`
- `tls_ca.crt`
- `versions`

### 10.4 Pi-hole Local Config Notes

An important finding from this capture is:

- `/etc/pihole/setupVars.conf` was **not found**
- `/etc/pihole` is clearly present and active
- Pi-hole is therefore installed and functioning, but it is not using that older expected file path, or that file is absent in this install

That means rebuild documentation should not rely on `setupVars.conf` as a required truth source.

### 10.5 dnsmasq Local Override

Current `/etc/dnsmasq.d` contains:

- `02-home-arpa.conf`

This strongly indicates a local DNS override for `home.arpa`, even though the exact file content was not captured in the successful dump.

### 10.6 Unbound Runtime State

Observed runtime facts:

- `unbound.service` is running
- Unbound listens on `127.0.0.1:5335` over both UDP and TCP

### 10.7 Verbatim Unbound Configuration

Current Unbound files:

```conf
# /etc/unbound/unbound.conf.d/pi-hole.conf
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

```conf
# /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf
server:
    # The following line will configure unbound to perform cryptographic
    # DNSSEC validation using the root trust anchor.
    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

```conf
# /etc/unbound/unbound.conf.d/remote-control.conf
remote-control:
  control-enable: yes
  # by default the control interface is is 127.0.0.1 and ::1 and port 8953
  # it is possible to use a unix socket too
  control-interface: /run/unbound.ctl
```

```conf
# /etc/unbound/unbound.conf
# Unbound configuration file for Debian.
#
# See the unbound.conf(5) man page.
#
# See /usr/share/doc/unbound/examples/unbound.conf for a commented
# reference config file.
#
# The following line includes additional configuration files from the
# /etc/unbound/unbound.conf.d directory.
include-toplevel: "/etc/unbound/unbound.conf.d/*.conf"
```

### 10.8 Practical DNS Flow

The intended DNS chain is:

1. Client queries Pi-hole
2. Pi-hole resolves local domains or forwards external lookups
3. Unbound performs recursive external resolution
4. Result returns through Pi-hole to the client

For the host itself, loopback resolution is active, but not exclusive.

### 10.9 DNS Caveats

Current DNS is working, but there are two documented caveats:

1. `resolvectl` shows public resolvers on `eno1` in addition to loopback.
2. `02-home-arpa.conf` exists but its exact content has not yet been captured into the document.

Neither issue prevents operation, but both matter for exact rebuild fidelity.

---

## 11. Reverse Proxy and Internal HTTPS

### 11.1 Caddy Runtime State

Observed runtime facts:

- `caddy.service` is running
- Caddy listens on port 80
- Caddy listens on port 443
- Caddy admin endpoint listens on `127.0.0.1:2019`

### 11.2 Caddy Global Configuration

Current Caddyfile begins with:

```caddy
{
        servers {
                protocols h1 h2
        }
}
```

This forces Caddy server protocols to HTTP/1.1 and HTTP/2.

### 11.3 Virtual Host Map

Current Caddyfile routes:

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

All sites use:

```caddy
tls internal
```

### 11.4 Verified HTTP Response Behavior

Verified behavior through reverse proxy:

| Hostname | Result | Meaning |
|---|---:|---|
| `dashboard.home.arpa` | 200 | Dashboard reachable |
| `uptime.home.arpa` | 302 | Redirect behavior correct |
| `sonarr.home.arpa` | 401 | Auth gate functioning |
| `radarr.home.arpa` | 401 | Auth gate functioning |
| `prowlarr.home.arpa` | 401 | Auth gate functioning |
| `jellyfin.home.arpa` | 302 | Redirect to web UI |
| `jellyseerr.home.arpa` | 307 | Redirect to login |
| `qbittorrent.home.arpa` | 200 | UI reachable |
| `flaresolverr.home.arpa` | 200 | API reachable |

### 11.5 Internal CA Trust Notes

Because the configuration uses `tls internal`, client devices must trust Caddy’s internal CA. Exact CA file paths were not captured in the latest successful dump, but this requirement remains true.

---

## 12. Docker Platform

### 12.1 Docker Runtime State

Current Docker info:

- **Containers:** 9 running, 0 paused, 0 stopped
- **Images:** 12
- **Server version:** 28.4.0
- **Storage driver:** overlay2
- **Backing filesystem:** extfs
- **Logging driver:** json-file
- **Swarm:** inactive
- **Default runtime:** runc
- **Security options:** apparmor, seccomp, cgroupns
- **Live Restore:** false

### 12.2 Docker Packaging Model

Current Docker is Snap-based, not apt-based.

Evidence:

- Docker root dir is `/var/snap/docker/common/var-lib-docker`
- Active service is `snap.docker.dockerd.service`

### 12.3 Compose Project State

Current Compose project:

- **Project name:** `homelab-compose`
- **Default network:** `homelab-compose_default`

Current Compose status:

- `flaresolverr` → Up
- `homarr` → Up
- `jellyfin` → Up, healthy
- `jellyseerr` → Up
- `prowlarr` → Up
- `qbittorrent` → Up
- `radarr` → Up
- `sonarr` → Up
- `uptime-kuma` → Up, healthy

### 12.4 Docker Networking

Observed Docker networks:

- `bridge`
- `homelab-compose_default`
- `host`
- `none`

Important implication:

- application containers are not using the legacy default bridge only
- they are using the dedicated Compose bridge network
- host-exposed ports are used for reverse proxy routing

### 12.5 Docker Storage Model

Observed Docker volumes:

- none

This is important. No named Docker volumes are currently used. All persistent state is through bind mounts. This makes backup and manual inspection simpler, but it also means directory paths on the host are critical and must be preserved in any rebuild.

---

## 13. Full Application Inventory

### 13.1 Homarr

- **Image:** `ghcr.io/homarr-labs/homarr:latest`
- **Container name:** `homarr`
- **Port mapping:** `7575:7575`
- **Restart policy:** `unless-stopped`

#### Environment

- `SECRET_ENCRYPTION_KEY=ab2149cb0b7197fac238c7074ce014e59d19ba2fa5257556e75a278200c66243`
- `DB_URL=/appdata/db/db.sqlite`
- `DB_DIALECT=sqlite`
- `DB_DRIVER=better-sqlite3`
- `AUTH_PROVIDERS=credentials`
- `REDIS_IS_EXTERNAL=false`
- `NODE_ENV=production`

#### Bind mounts

- `/home/nodezero/homarr/appdata:/appdata`
- `/var/run/docker.sock:/var/run/docker.sock`

#### Purpose

Homarr is the main dashboard and front door for the homelab. It provides a centralized access surface for services and integrates with Docker through the mounted socket.

---

### 13.2 Uptime Kuma

- **Image:** `louislam/uptime-kuma`
- **Container name:** `uptime-kuma`
- **Port mapping:** `3002:3001`
- **Restart policy:** `unless-stopped`
- **Health:** healthy

#### Environment

- `UPTIME_KUMA_IS_CONTAINER=1`

#### DNS override

- `192.168.1.181`

#### Bind mounts

- `/home/nodezero/uptime:/app/data`

#### Purpose

Uptime Kuma provides local service monitoring and endpoint validation. The DNS override is specifically important because it allows the container to resolve the internal `home.arpa` service names against the host’s local DNS stack.

---

### 13.3 FlareSolverr

- **Image:** `ghcr.io/flaresolverr/flaresolverr:latest`
- **Container name:** `flaresolverr`
- **Port mapping:** `8191:8191`
- **Restart policy:** `unless-stopped`

#### Environment

- `LOG_LEVEL=info`

#### Bind mounts

- `/home/nodezero/flaresolverr:/config`

#### Purpose

FlareSolverr provides anti-bot solving support for indexer-related workflows.

---

### 13.4 qBittorrent

- **Image:** `lscr.io/linuxserver/qbittorrent`
- **Container name:** `qbittorrent`
- **Port mapping:** `8080:8080`
- **Restart policy:** `unless-stopped`

#### Other exposed ports

- `6881/tcp`
- `6881/udp`

#### Environment

- `PUID=1000`
- `PGID=1000`
- `WEBUI_PORT=8080`

#### Bind mounts

- `/home/nodezero/qbittorrent/config:/config`
- `/mnt/hdd/downloads:/downloads`

#### Purpose

qBittorrent is the downloader for the media pipeline. It stores downloads on the shared media disk and exposes its Web UI on port 8080.

---

### 13.5 Jellyfin

- **Image:** `jellyfin/jellyfin`
- **Container name:** `jellyfin`
- **Port mapping:** `8096:8096`
- **Restart policy:** `unless-stopped`
- **Health:** healthy

#### Environment

- `JELLYFIN_DATA_DIR=/config`
- `JELLYFIN_CACHE_DIR=/cache`
- `JELLYFIN_CONFIG_DIR=/config/config`
- `JELLYFIN_LOG_DIR=/config/log`
- `JELLYFIN_WEB_DIR=/jellyfin/jellyfin-web`
- `JELLYFIN_FFMPEG=/usr/lib/jellyfin-ffmpeg/ffmpeg`
- `XDG_CACHE_HOME=/cache`
- `MALLOC_TRIM_THRESHOLD_=131072`
- `NVIDIA_VISIBLE_DEVICES=all`
- `NVIDIA_DRIVER_CAPABILITIES=compute,video,utility`
- `LD_PRELOAD=/usr/lib/jellyfin/libjemalloc.so.2`

#### Bind mounts

- `/home/nodezero/jellyfin/cache:/cache`
- `/home/nodezero/jellyfin/config:/config`
- `/mnt/hdd:/media`

#### Purpose

Jellyfin is the media server. It sees the whole `/mnt/hdd` tree as `/media`, which makes it suitable for multiple libraries under one mount point.

#### Note

GPU-related NVIDIA environment variables are present, but this does not by itself prove active hardware transcoding. It only shows the container is configured with those variables.

---

### 13.6 Jellyseerr

- **Image:** `fallenbagel/jellyseerr`
- **Container name:** `jellyseerr`
- **Port mapping:** `5056:5055`
- **Restart policy:** `unless-stopped`

#### Bind mounts

- `/home/nodezero/jellyseerr/config:/app/config`

#### Purpose

Jellyseerr handles requests for media and integrates with Sonarr and Radarr.

#### Important detail

This service is exposed on host port `5056`, but the container listens on internal port `5055`. This mapping must be preserved exactly in any rebuild.

---

### 13.7 Prowlarr

- **Image:** `linuxserver/prowlarr`
- **Container name:** `prowlarr`
- **Port mapping:** `9696:9696`
- **Restart policy:** `unless-stopped`

#### Environment

- `PUID=911`
- `PGID=911`

#### Bind mounts

- `/home/nodezero/prowlarr/config:/config`

#### Purpose

Prowlarr is the indexer manager for Sonarr and Radarr.

---

### 13.8 Radarr

- **Image:** `linuxserver/radarr`
- **Container name:** `radarr`
- **Port mapping:** `7878:7878`
- **Restart policy:** `unless-stopped`

#### Environment

- `PUID=911`
- `PGID=911`

#### Bind mounts

- `/home/nodezero/radarr/config:/config`
- `/mnt/hdd/downloads:/downloads`
- `/mnt/hdd/movies:/movies`

#### Purpose

Radarr handles movie automation, import, and organization.

---

### 13.9 Sonarr

- **Image:** `linuxserver/sonarr`
- **Container name:** `sonarr`
- **Port mapping:** `8989:8989`
- **Restart policy:** `unless-stopped`

#### Environment

- `PUID=911`
- `PGID=911`
- `SONARR_CHANNEL=v4-stable`
- `SONARR_BRANCH=main`

#### Bind mounts

- `/home/nodezero/sonarr/config:/config`
- `/mnt/hdd/downloads:/downloads`
- `/mnt/hdd/tv:/tv`

#### Purpose

Sonarr handles television automation, import, and organization.

---

## 14. Full Compose Configuration

The current deployed Compose file is:

```yaml
services:
  homarr:
    image: ghcr.io/homarr-labs/homarr:latest
    container_name: homarr
    restart: unless-stopped
    ports:
      - "7575:7575"
    environment:
      SECRET_ENCRYPTION_KEY: "ab2149cb0b7197fac238c7074ce014e59d19ba2fa5257556e75a278200c66243"
      DB_URL: "/appdata/db/db.sqlite"
      DB_DIALECT: "sqlite"
      DB_DRIVER: "better-sqlite3"
      AUTH_PROVIDERS: "credentials"
      REDIS_IS_EXTERNAL: "false"
      NODE_ENV: "production"
    volumes:
      - /home/nodezero/homarr/appdata:/appdata
      - /var/run/docker.sock:/var/run/docker.sock

  uptime-kuma:
    image: louislam/uptime-kuma
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3002:3001"
    dns:
      - 192.168.1.181
    environment:
      UPTIME_KUMA_IS_CONTAINER: "1"
    volumes:
      - /home/nodezero/uptime:/app/data

  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    restart: unless-stopped
    ports:
      - "8191:8191"
    environment:
      LOG_LEVEL: "info"
    volumes:
      - /home/nodezero/flaresolverr:/config

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent
    container_name: qbittorrent
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      PUID: "1000"
      PGID: "1000"
      WEBUI_PORT: "8080"
    volumes:
      - /home/nodezero/qbittorrent/config:/config
      - /mnt/hdd/downloads:/downloads

  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    environment:
      JELLYFIN_DATA_DIR: "/config"
      JELLYFIN_CACHE_DIR: "/cache"
      JELLYFIN_CONFIG_DIR: "/config/config"
      JELLYFIN_LOG_DIR: "/config/log"
      JELLYFIN_WEB_DIR: "/jellyfin/jellyfin-web"
      JELLYFIN_FFMPEG: "/usr/lib/jellyfin-ffmpeg/ffmpeg"
      XDG_CACHE_HOME: "/cache"
      MALLOC_TRIM_THRESHOLD_: "131072"
      NVIDIA_VISIBLE_DEVICES: "all"
      NVIDIA_DRIVER_CAPABILITIES: "compute,video,utility"
      LD_PRELOAD: "/usr/lib/jellyfin/libjemalloc.so.2"
    volumes:
      - /home/nodezero/jellyfin/cache:/cache
      - /home/nodezero/jellyfin/config:/config
      - /mnt/hdd:/media

  jellyseerr:
    image: fallenbagel/jellyseerr
    container_name: jellyseerr
    restart: unless-stopped
    ports:
      - "5056:5055"
    volumes:
      - /home/nodezero/jellyseerr/config:/app/config

  prowlarr:
    image: linuxserver/prowlarr
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      PUID: "911"
      PGID: "911"
    volumes:
      - /home/nodezero/prowlarr/config:/config

  radarr:
    image: linuxserver/radarr
    container_name: radarr
    restart: unless-stopped
    ports:
      - "7878:7878"
    environment:
      PUID: "911"
      PGID: "911"
    volumes:
      - /home/nodezero/radarr/config:/config
      - /mnt/hdd/downloads:/downloads
      - /mnt/hdd/movies:/movies

  sonarr:
    image: linuxserver/sonarr
    container_name: sonarr
    restart: unless-stopped
    ports:
      - "8989:8989"
    environment:
      PUID: "911"
      PGID: "911"
      SONARR_CHANNEL: "v4-stable"
      SONARR_BRANCH: "main"
    volumes:
      - /home/nodezero/sonarr/config:/config
      - /mnt/hdd/downloads:/downloads
      - /mnt/hdd/tv:/tv
```

---

## 15. Port Exposure Inventory

### 15.1 Container and Proxy Ports

#### Compose-managed applications

- 7575 → Homarr
- 3002 → Uptime Kuma
- 8191 → FlareSolverr
- 8080 → qBittorrent
- 8096 → Jellyfin
- 5056 → Jellyseerr
- 9696 → Prowlarr
- 7878 → Radarr
- 8989 → Sonarr

#### Caddy reverse proxy

- 80 → Caddy
- 443 → Caddy

### 15.2 Host Service Ports

Observed host-native services:

- 53 UDP/TCP → Pi-hole FTL
- 3000 TCP → Pi-hole admin backend
- 5335 UDP/TCP on 127.0.0.1 → Unbound
- 22 TCP → SSH
- 139 TCP → Samba
- 445 TCP → Samba
- 2019 TCP on 127.0.0.1 → Caddy admin endpoint
- 41641 UDP → Tailscale

### 15.3 Other Observed Listening Services

The host also has non-homelab service listeners, including:

- Avahi on 5353 UDP
- NoMachine server and related NX ports on 4000 and localhost-bound ports
- CUPS on 631 localhost
- Chrony on 323 localhost
- nmbd UDP ports 137 and 138 across several interfaces

These are part of the host environment and should be documented because they affect the attack surface and service inventory.

---

## 16. Service and Process Inventory

Current running systemd services of operational importance:

- `caddy.service`
- `pihole-FTL.service`
- `unbound.service`
- `tailscaled.service`
- `ssh.service`
- `snap.docker.dockerd.service`
- `smbd.service`
- `nmbd.service`
- `NetworkManager.service`
- `systemd-resolved.service`
- `chrony.service`
- `lightdm.service`
- `nxserver.service`
- `cups.service`
- `cups-browsed.service`
- `avahi-daemon.service`
- `unattended-upgrades.service`

This means NodeZero is not a minimal headless server. It is running several desktop and convenience services, including LightDM, Bluetooth, CUPS, Avahi, and NoMachine.

---

## 17. Samba Configuration

Current `/etc/samba/smb.conf` content:

```conf
[global]
   workgroup = WORKGROUP
   server string = NodeZero SMB
   map to guest = Bad User
   dns proxy = no

[hdd]
   path = /mnt/hdd
   browseable = yes
   read only = no
   writable = yes
   guest ok = no
   valid users = nodezero
   force user = nodezero
   create mask = 0664
   directory mask = 0775
```

Interpretation:

- Samba exports `/mnt/hdd`
- authenticated access is restricted to `nodezero`
- all file operations are forced as `nodezero`
- file creation mask is `0664`
- directory creation mask is `0775`

This is a clean and practical share model for a single-user homelab.

---

## 18. Security Model

### 18.1 Positive Security Properties

- Services are primarily intended to be accessed through internal HTTPS hostnames
- Caddy terminates TLS with internal certificates
- Remote access is available through Tailscale
- Core DNS is local
- Containers are isolated on a Compose bridge network
- Uptime Kuma and Jellyfin health states are good
- No public cloud exposure is implied by the current config

### 18.2 Observed Security Gaps and Tradeoffs

- **UFW is inactive**
- application ports are host-exposed directly, even though the preferred access model is via Caddy
- Samba is active and listening on 139 and 445
- NoMachine is installed and listening
- Avahi is active
- desktop stack is active on a server-like host
- `/var/run/docker.sock` is mounted into Homarr, which is useful but privileged
- internal TLS depends on clients trusting the Caddy CA
- current resolver model includes external DNS servers in addition to loopback

Overall, the system is reasonably safe for a local homelab, but it is not hardened to a minimalist security posture.

---

## 19. Media Pipeline Architecture

The functional media pipeline is:

1. User requests content in Jellyseerr
2. Jellyseerr forwards requests to Sonarr or Radarr
3. Sonarr and Radarr use Prowlarr-managed indexers
4. Download jobs are sent to qBittorrent
5. qBittorrent writes to `/mnt/hdd/downloads`
6. Sonarr or Radarr imports completed media into `/mnt/hdd/tv` or `/mnt/hdd/movies`
7. Jellyfin serves media libraries from `/mnt/hdd` exposed as `/media`

FlareSolverr exists as support infrastructure for indexer access where anti-bot handling is needed.

This layout is clean because the container paths are consistent:

- qBittorrent sees `/downloads`
- Sonarr sees `/downloads` and `/tv`
- Radarr sees `/downloads` and `/movies`
- Jellyfin sees `/media`

That consistency reduces path-mapping failures.

---

## 20. Permissions and Ownership Model

### Verified current identity use in containers

- qBittorrent uses `PUID=1000`, `PGID=1000`
- Prowlarr uses `PUID=911`, `PGID=911`
- Radarr uses `PUID=911`, `PGID=911`
- Sonarr uses `PUID=911`, `PGID=911`

### Verified Samba ownership behavior

Samba forces access as:

- `force user = nodezero`

### Practical implication

A rebuild must preserve ownership compatibility between:

- the host user `nodezero`
- LinuxServer containers using UID/GID 911
- qBittorrent using UID/GID 1000
- Samba forcing writes as `nodezero`

### Rebuild-aligned ownership commands

```bash
sudo chown -R nodezero:nodezero /home/nodezero/homarr
sudo chown -R nodezero:nodezero /home/nodezero/uptime
sudo chown -R nodezero:nodezero /home/nodezero/flaresolverr
sudo chown -R nodezero:nodezero /home/nodezero/qbittorrent
sudo chown -R nodezero:nodezero /home/nodezero/jellyfin
sudo chown -R nodezero:nodezero /home/nodezero/jellyseerr

sudo chown -R 911:911 /home/nodezero/prowlarr
sudo chown -R 911:911 /home/nodezero/radarr
sudo chown -R 911:911 /home/nodezero/sonarr

sudo chown -R nodezero:nodezero /mnt/hdd
```

---

## 21. Operational Workflows

### 21.1 Standard Compose Lifecycle Commands

Start stack:

```bash
cd ~/homelab-compose && docker compose up -d
```

Stop stack:

```bash
cd ~/homelab-compose && docker compose down
```

Check state:

```bash
cd ~/homelab-compose && docker compose ps
```

Tail logs:

```bash
cd ~/homelab-compose && docker compose logs --tail 100
```

### 21.2 Validation Commands

Check reverse-proxied endpoints:

```bash
curl -kI https://dashboard.home.arpa
curl -kI https://uptime.home.arpa
curl -kI https://sonarr.home.arpa
curl -kI https://radarr.home.arpa
curl -kI https://prowlarr.home.arpa
curl -kI https://jellyfin.home.arpa
curl -kI https://jellyseerr.home.arpa
curl -kI https://qbittorrent.home.arpa
curl -kI https://flaresolverr.home.arpa
```

Check open ports:

```bash
sudo ss -tulpn
```

Check container status:

```bash
docker ps
docker compose ps
```

### 21.3 Update Workflow

Standard Compose update cycle:

```bash
cd ~/homelab-compose && docker compose pull && docker compose up -d
```

This was tested successfully in the live system state and all containers came back up cleanly.

### 21.4 Post-Change Validation Checklist

After any significant change:

1. Check containers:
   ```bash
   docker ps
   docker compose ps
   ```

2. Check reverse proxy:
   ```bash
   curl -kI https://dashboard.home.arpa
   curl -kI https://uptime.home.arpa
   curl -kI https://jellyfin.home.arpa
   ```

3. Check DNS:
   ```bash
   cat /etc/resolv.conf
   resolvectl status
   sudo ss -tulpn | grep -E '(:53|:5335)'
   ```

4. Check Caddy:
   ```bash
   sudo systemctl status caddy
   ```

5. Check storage:
   ```bash
   df -h
   ```

---

## 22. Rebuild From Zero Procedure

### 22.1 Hardware and Base OS

1. Install Ubuntu 25.10
2. Set hostname to `nodezero`
3. Create primary user `nodezero`
4. Ensure the data disk is physically attached
5. Ensure LAN connectivity is working
6. Ensure the host receives or is assigned LAN IP `192.168.1.181` if exact network parity is desired

### 22.2 Initial Host Preparation

Install core basics:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git nano htop unzip ca-certificates unbound samba
```

### 22.3 Create Persistent Directory Layout

Create required directories:

```bash
mkdir -p /home/nodezero/homarr/appdata
mkdir -p /home/nodezero/uptime
mkdir -p /home/nodezero/flaresolverr
mkdir -p /home/nodezero/qbittorrent/config
mkdir -p /home/nodezero/jellyfin/cache
mkdir -p /home/nodezero/jellyfin/config
mkdir -p /home/nodezero/jellyseerr/config
mkdir -p /home/nodezero/prowlarr/config
mkdir -p /home/nodezero/radarr/config
mkdir -p /home/nodezero/sonarr/config
mkdir -p /mnt/hdd/downloads
mkdir -p /mnt/hdd/movies
mkdir -p /mnt/hdd/tv
mkdir -p /home/nodezero/homelab-compose
```

### 22.4 Configure Data Mount

Use the data disk UUID in `/etc/fstab`:

```fstab
UUID=34f174a0-9d97-49d1-9d07-16799356b269 /mnt/hdd ext4 defaults,nofail 0 2
```

Then mount:

```bash
sudo mount -a
```

Verify:

```bash
df -h
```

### 22.5 Install Docker and Compose

To match the live installation model:

```bash
sudo snap install docker
sudo usermod -aG docker $USER
newgrp docker
docker version
docker info
```

Expected indicators:

- Docker root under `/var/snap/docker/common/var-lib-docker`
- Compose plugin present
- overlay2 storage driver
- cgroup v2 active

### 22.6 Install and Configure Caddy

Install Caddy:

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy
```

Write the Caddyfile from Appendix B into `/etc/caddy/Caddyfile`, then:

```bash
sudo systemctl enable --now caddy
sudo systemctl restart caddy
sudo systemctl status caddy
```

### 22.7 Install and Configure Pi-hole and Unbound

Install Pi-hole:

```bash
curl -sSL https://install.pi-hole.net | bash
```

Install or confirm Unbound:

```bash
sudo apt install -y unbound
```

Create the Unbound files from Appendix D, then:

```bash
sudo systemctl enable --now unbound
sudo systemctl restart unbound
sudo systemctl status unbound
```

Important rebuild note:

- Pi-hole is clearly installed and active in `/etc/pihole`
- `setupVars.conf` was not present on the live system
- do not assume that file is required for successful rebuild validation

Also ensure `/etc/dnsmasq.d/02-home-arpa.conf` exists to provide local domain handling for `home.arpa`.

### 22.8 Install and Configure Tailscale

Install and authenticate Tailscale:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

### 22.9 Install and Configure Samba

Install Samba:

```bash
sudo apt install -y samba
```

Write `/etc/samba/smb.conf` using the live configuration from Appendix E, then:

```bash
sudo systemctl enable --now smbd
sudo systemctl enable --now nmbd
sudo systemctl restart smbd
sudo systemctl restart nmbd
```

### 22.10 Deploy Compose Stack

Write `compose.yaml` exactly as in Appendix A:

```bash
cd /home/nodezero/homelab-compose
nano compose.yaml
docker compose config
docker compose up -d
```

### 22.11 Validate Rebuild

Validate all of the following:

1. Docker containers running:
   ```bash
   docker ps
   docker compose ps
   ```

2. Reverse proxy:
   ```bash
   curl -kI https://dashboard.home.arpa
   curl -kI https://uptime.home.arpa
   curl -kI https://sonarr.home.arpa
   curl -kI https://radarr.home.arpa
   curl -kI https://prowlarr.home.arpa
   curl -kI https://jellyfin.home.arpa
   curl -kI https://jellyseerr.home.arpa
   curl -kI https://qbittorrent.home.arpa
   curl -kI https://flaresolverr.home.arpa
   ```

3. DNS:
   ```bash
   cat /etc/resolv.conf
   resolvectl status
   sudo ss -tulpn | grep -E '(:53|:5335)'
   ```

4. Caddy:
   ```bash
   sudo systemctl status caddy
   sudo ss -tulpn | grep -E '(:80|:443|:2019)'
   ```

5. Storage:
   ```bash
   df -h
   ls -ld /mnt/hdd /mnt/hdd/downloads /mnt/hdd/movies /mnt/hdd/tv
   ```

If all checks pass, the homelab is functionally rebuilt.

---

## 23. Backup and Recovery Recommendations

### 23.1 What Must Be Backed Up

#### Host-level configuration

- `/etc/caddy/Caddyfile`
- `/etc/fstab`
- `/etc/unbound/unbound.conf`
- `/etc/unbound/unbound.conf.d/`
- `/etc/samba/smb.conf`
- `/etc/pihole/`
- `/etc/dnsmasq.d/`

#### Compose deployment definition

- `/home/nodezero/homelab-compose/compose.yaml`

#### Application state

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

#### Media content

- `/mnt/hdd/downloads`
- `/mnt/hdd/movies`
- `/mnt/hdd/tv`

### 23.2 Example Backup Commands

```bash
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
```

### 23.3 Recovery Order

If rebuilding after failure, restore in this order:

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

---

## 24. Known Constraints and Notes

- Docker is Snap-based, not apt-based
- UFW is inactive
- named Docker volumes are not used
- internal TLS requires trusted Caddy CA on client devices
- resolver file includes external DNS servers in addition to loopback
- desktop and convenience services exist on the host, including LightDM, Bluetooth, CUPS, Avahi, and NoMachine
- Samba is enabled and exposed
- qBittorrent exposes torrent ports
- Homarr has Docker socket access
- current system is single-node with no HA
- current data disk is 73% used
- `/etc/pihole/setupVars.conf` was absent on the live system
- `/etc/dnsmasq.d/02-home-arpa.conf` exists but its contents were not captured in the successful dump

---

## 25. Final Assessment

NodeZero is in a strong operational state.

### What is clearly working

- internal DNS
- recursive DNS
- reverse proxy
- internal TLS
- Compose-managed application stack
- monitoring
- media automation stack
- streaming
- requests pipeline
- Tailscale remote access
- Samba file sharing
- reproducible container lifecycle

### What is most valuable about the current state

- the stack is no longer hand-managed
- the Compose definition is explicit
- bind mounts preserve all critical application state
- reverse proxy mapping is simple and clean
- rebuild is now practical rather than theoretical

### Main next priorities

1. backups
2. capture the contents of `02-home-arpa.conf`
3. optionally capture final ownership and ACL evidence
4. optionally harden host services and firewall posture

Overall, NodeZero is stable, maintainable, and rebuildable from documented state.

---

## Appendix A. Current Compose YAML

```yaml
services:
  homarr:
    image: ghcr.io/homarr-labs/homarr:latest
    container_name: homarr
    restart: unless-stopped
    ports:
      - "7575:7575"
    environment:
      SECRET_ENCRYPTION_KEY: "ab2149cb0b7197fac238c7074ce014e59d19ba2fa5257556e75a278200c66243"
      DB_URL: "/appdata/db/db.sqlite"
      DB_DIALECT: "sqlite"
      DB_DRIVER: "better-sqlite3"
      AUTH_PROVIDERS: "credentials"
      REDIS_IS_EXTERNAL: "false"
      NODE_ENV: "production"
    volumes:
      - /home/nodezero/homarr/appdata:/appdata
      - /var/run/docker.sock:/var/run/docker.sock

  uptime-kuma:
    image: louislam/uptime-kuma
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3002:3001"
    dns:
      - 192.168.1.181
    environment:
      UPTIME_KUMA_IS_CONTAINER: "1"
    volumes:
      - /home/nodezero/uptime:/app/data

  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    restart: unless-stopped
    ports:
      - "8191:8191"
    environment:
      LOG_LEVEL: "info"
    volumes:
      - /home/nodezero/flaresolverr:/config

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent
    container_name: qbittorrent
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      PUID: "1000"
      PGID: "1000"
      WEBUI_PORT: "8080"
    volumes:
      - /home/nodezero/qbittorrent/config:/config
      - /mnt/hdd/downloads:/downloads

  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    environment:
      JELLYFIN_DATA_DIR: "/config"
      JELLYFIN_CACHE_DIR: "/cache"
      JELLYFIN_CONFIG_DIR: "/config/config"
      JELLYFIN_LOG_DIR: "/config/log"
      JELLYFIN_WEB_DIR: "/jellyfin/jellyfin-web"
      JELLYFIN_FFMPEG: "/usr/lib/jellyfin-ffmpeg/ffmpeg"
      XDG_CACHE_HOME: "/cache"
      MALLOC_TRIM_THRESHOLD_: "131072"
      NVIDIA_VISIBLE_DEVICES: "all"
      NVIDIA_DRIVER_CAPABILITIES: "compute,video,utility"
      LD_PRELOAD: "/usr/lib/jellyfin/libjemalloc.so.2"
    volumes:
      - /home/nodezero/jellyfin/cache:/cache
      - /home/nodezero/jellyfin/config:/config
      - /mnt/hdd:/media

  jellyseerr:
    image: fallenbagel/jellyseerr
    container_name: jellyseerr
    restart: unless-stopped
    ports:
      - "5056:5055"
    volumes:
      - /home/nodezero/jellyseerr/config:/app/config

  prowlarr:
    image: linuxserver/prowlarr
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      PUID: "911"
      PGID: "911"
    volumes:
      - /home/nodezero/prowlarr/config:/config

  radarr:
    image: linuxserver/radarr
    container_name: radarr
    restart: unless-stopped
    ports:
      - "7878:7878"
    environment:
      PUID: "911"
      PGID: "911"
    volumes:
      - /home/nodezero/radarr/config:/config
      - /mnt/hdd/downloads:/downloads
      - /mnt/hdd/movies:/movies

  sonarr:
    image: linuxserver/sonarr
    container_name: sonarr
    restart: unless-stopped
    ports:
      - "8989:8989"
    environment:
      PUID: "911"
      PGID: "911"
      SONARR_CHANNEL: "v4-stable"
      SONARR_BRANCH: "main"
    volumes:
      - /home/nodezero/sonarr/config:/config
      - /mnt/hdd/downloads:/downloads
      - /mnt/hdd/tv:/tv
```

---

## Appendix B. Current Caddyfile

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

---

## Appendix C. Current fstab

```fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/147f22a2-1432-419a-82be-f0d12bd9378a / ext4 defaults 0 1
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/0DCA-96B4 /boot/efi vfat defaults 0 1
/swap.img       none    swap    sw      0       0
UUID=34f174a0-9d97-49d1-9d07-16799356b269 /mnt/hdd ext4 defaults,nofail 0 2
```

---

## Appendix D. Verbatim Unbound Files

```conf
# /etc/unbound/unbound.conf.d/pi-hole.conf
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

```conf
# /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf
server:
    # The following line will configure unbound to perform cryptographic
    # DNSSEC validation using the root trust anchor.
    auto-trust-anchor-file: "/var/lib/unbound/root.key"
```

```conf
# /etc/unbound/unbound.conf.d/remote-control.conf
remote-control:
  control-enable: yes
  # by default the control interface is is 127.0.0.1 and ::1 and port 8953
  # it is possible to use a unix socket too
  control-interface: /run/unbound.ctl
```

```conf
# /etc/unbound/unbound.conf
# Unbound configuration file for Debian.
#
# See the unbound.conf(5) man page.
#
# See /usr/share/doc/unbound/examples/unbound.conf for a commented
# reference config file.
#
# The following line includes additional configuration files from the
# /etc/unbound/unbound.conf.d directory.
include-toplevel: "/etc/unbound/unbound.conf.d/*.conf"
```

---

## Appendix E. Verbatim Samba Configuration

```conf
[global]
   workgroup = WORKGROUP
   server string = NodeZero SMB
   map to guest = Bad User
   dns proxy = no

[hdd]
   path = /mnt/hdd
   browseable = yes
   read only = no
   writable = yes
   guest ok = no
   valid users = nodezero
   force user = nodezero
   create mask = 0664
   directory mask = 0775
```

---

## Appendix F. Verbatim Resolver Output

```conf
# /etc/resolv.conf
# This is /run/systemd/resolve/resolv.conf managed by man:systemd-resolved(8).
# Do not edit.
#
# This file might be symlinked as /etc/resolv.conf. If you're looking at
# /etc/resolv.conf and seeing this text, you have followed the symlink.
#
# This is a dynamic resolv.conf file for connecting local clients directly to
# all known uplink DNS servers. This file lists all configured search domains.
#
# Third party programs should typically not access this file directly, but only
# through the symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a
# different way, replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 127.0.0.1
nameserver 1.1.1.1
nameserver 8.8.8.8
# Too many DNS servers configured, the following entries may be ignored.
nameserver 127.0.0.1
search .
```

```text
# resolvectl status, relevant lines
Global
         Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
  resolv.conf mode: uplink
       DNS Servers: 127.0.0.1 127.0.0.1
        DNS Domain: ~.

Link 2 (eno1)
    Current Scopes: DNS
         Protocols: +DefaultRoute -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
       DNS Servers: 1.1.1.1 8.8.8.8 127.0.0.1
     Default Route: yes
```

---

## Appendix G. Verbatim Curl Validation Output

```text
dashboard.home.arpa -> HTTP/2 200
uptime.home.arpa    -> HTTP/2 302
sonarr.home.arpa    -> HTTP/2 401
radarr.home.arpa    -> HTTP/2 401
prowlarr.home.arpa  -> HTTP/2 401
jellyfin.home.arpa  -> HTTP/2 302
jellyseerr.home.arpa -> HTTP/2 307
qbittorrent.home.arpa -> HTTP/2 200
flaresolverr.home.arpa -> HTTP/2 200
```
