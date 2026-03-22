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

~~~bash
sudo apt install -y samba
sudo systemctl enable --now smbd
sudo systemctl enable --now nmbd
~~~

### Deploy Compose Stack

Write `compose.yaml`, then:

~~~bash
cd /home/nodezero/homelab-compose
docker compose config
docker compose up -d
~~~

### Validate Rebuild

Validate:

1. Docker containers running
2. Reverse proxy responses
3. DNS behavior
4. Caddy state
5. Storage mounts
