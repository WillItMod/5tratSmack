# Proxmox installation

The Proxmox helper creates a dedicated unprivileged Debian LXC container. It
installs Docker and 5tratSmack inside the guest, never on the Proxmox VE host.

## Default installation

Run as `root` in the Proxmox shell:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.10.17-linux
  curl -fSLO "$base/proxmox-helper.sh"
  curl -fSLO "$base/proxmox-helper.sh.sha256"
  sha256sum -c proxmox-helper.sh.sha256
  bash proxmox-helper.sh --release-tag v0.10.17-linux
)
```

The helper selects the next free VMID and suitable active LXC storage. Its
defaults are:

- Unprivileged Debian 12 or 13 LXC
- Hostname `5tratsmack`
- DHCP on `vmbr0`
- 80 GiB root disk
- Four CPU cores
- 8 GiB memory and 1 GiB swap
- Start automatically with Proxmox

Downloaded installation files are kept in a temporary directory inside the
guest and removed when the helper exits.

## Static-address example

Choose values appropriate for the local network:

```bash
bash proxmox-helper.sh \
  --release-tag v0.10.17-linux \
  --vmid 144 \
  --hostname 5tratsmack-node \
  --storage local-lvm \
  --bridge vmbr0 \
  --ip 192.168.1.144/24 \
  --gateway 192.168.1.1 \
  --disk-gb 100 \
  --cores 6 \
  --memory-mb 8192
```

Run the downloaded helper with `--help` to list every supported option. The
selected VMID must not already exist, and the named storage must support LXC
root disks.

## After installation

The helper prints the guest address when DHCP has assigned one:

- Web application: `http://GUEST_IP:3015`
- Miner Stratum: `stratum+tcp://GUEST_IP:57557`
- 5TRAT P2P: `GUEST_IP:57555/TCP`

Wait for synchronization, create or restore the wallet, and export an
encrypted backup before mining.

## Public-node networking

The guest is already a complete validating node. It needs no inbound port to
synchronize. UPnP can map TCP 57555 automatically when the router supports it.
If UPnP is unavailable and inbound replication is wanted, manually forward
public TCP 57555 to the LXC guest address.

When several 5TRAT nodes share one router, forward TCP 57555 to only one of
them. The remaining nodes should stay outbound-only. Never forward the
Proxmox management port, wallet RPC, application UI or Stratum port as part of
node sharing.
