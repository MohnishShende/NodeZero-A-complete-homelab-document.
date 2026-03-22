# Recovery

## Rebuild From Zero Procedure

### Hardware and Base OS

1. Install Ubuntu 25.10
2. Set hostname to `nodezero`
3. Create primary user `nodezero`
4. Ensure the data disk is physically attached
5. Ensure LAN connectivity is working
6. Ensure the host receives or is assigned LAN IP `192.168.1.181` if exact network parity is desired

### Initial Host Preparation

~~~bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git nano htop unzip ca-certificates unbound samba
~~~

### Create Persistent Directory Layout

~~~bash
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
~~~

### Configure Data Mount

~~~fstab
UUID=34f174a0-9d97-49d1-9d07-16799356b269 /mnt/hdd ext4 defaults,nofail 0 2
~~~

Then:

~~~bash
sudo mount -a
df -h
~~~

### Install Docker and Compose

To match the live installation model:

~~~bash
sudo snap install docker
sudo usermod -aG docker $USER
newgrp docker
docker version
docker info
~~~

### Install and Configure Caddy

~~~bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy
sudo systemctl enable --now caddy
~~~

### Install and Configure Pi-hole and Unbound

~~~bash
curl -sSL https://install.pi-hole.net | bash
sudo apt install -y unbound
sudo systemctl enable --now unbound
sudo systemctl restart unbound
~~~

### Important Rebuild Note

- Pi-hole is clearly installed and active in `/etc/pihole`
- `setupVars.conf` was absent on the live system
- do not assume that file is required for successful rebuild validation
- ensure `/etc/dnsmasq.d/02-home-arpa.conf` exists to provide local domain handling for `home.arpa`

### Install and Configure Tailscale

~~~bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
~~~

### Install and Configure Samba

```bash
sudo apt install -y samba
```

Write `/etc/samba/smb.conf`:

```ini
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

Then:

```bash
sudo smbpasswd -a nodezero
sudo systemctl enable --now smbd
sudo systemctl enable --now nmbd
sudo systemctl restart smbd
sudo systemctl restart nmbd
```

### Set Ownership and Permissions

After all directories are created, apply correct ownership for each service:

```bash
# nodezero-owned services
sudo chown -R nodezero:nodezero /home/nodezero/homarr
sudo chown -R nodezero:nodezero /home/nodezero/uptime
sudo chown -R nodezero:nodezero /home/nodezero/flaresolverr
sudo chown -R nodezero:nodezero /home/nodezero/qbittorrent
sudo chown -R nodezero:nodezero /home/nodezero/jellyfin
sudo chown -R nodezero:nodezero /home/nodezero/jellyseerr

# LinuxServer containers use UID/GID 911
sudo chown -R 911:911 /home/nodezero/prowlarr
sudo chown -R 911:911 /home/nodezero/radarr
sudo chown -R 911:911 /home/nodezero/sonarr

# Media disk owned by nodezero (Samba forces this)
sudo chown -R nodezero:nodezero /mnt/hdd
```

### Deploy Compose Stack

Copy `compose.yaml` from this repository to `/home/nodezero/homelab-compose/compose.yaml`, then:

```bash
cd /home/nodezero/homelab-compose
docker compose config
docker compose up -d
```

### Validate Rebuild

**1. Docker containers running:**

```bash
docker ps
docker compose ps
```

Expected: 9 containers up, `jellyfin` and `uptime-kuma` showing healthy.

**2. Reverse proxy:**

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

Expected: 200/302/307/401 responses as documented in `docs/04-dns-and-https.md`.

**3. DNS:**

```bash
cat /etc/resolv.conf
resolvectl status
sudo ss -tulpn | grep -E '(:53|:5335)'
```

Expected: port 53 on `0.0.0.0`, port 5335 on `127.0.0.1`.

**4. Caddy:**

```bash
sudo systemctl status caddy
sudo ss -tulpn | grep -E '(:80|:443|:2019)'
```

**5. Storage:**

```bash
df -h
ls -ld /mnt/hdd /mnt/hdd/downloads /mnt/hdd/movies /mnt/hdd/tv
```

If all checks pass, the homelab is functionally rebuilt.
