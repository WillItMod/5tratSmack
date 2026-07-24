# Standalone Linux installation

The standalone package runs the same full validating 5TRAT node, wallet, solo
pool, explorer and atomic-trading application used by 5tratumOS. It does not
need an installation key or a GitHub account.

## Supported systems

- 64-bit AMD and Intel Linux (`linux/amd64`)
- 64-bit ARM Linux (`linux/arm64`), including recent Raspberry Pi systems
- Package managers supported by the bootstrap: `apt`, `dnf`, `yum`, `pacman`
  and `zypper`

ARM32 is not supported. The host must have a normal init system capable of
starting Docker. Debian 12/13 and Ubuntu 24.04 are the most thoroughly tested
standalone targets.

## Install

Download the installer and its checksum from the same immutable release:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.10.24-linux
  curl -fSLO "$base/install.sh"
  curl -fSLO "$base/install.sh.sha256"
  sha256sum -c install.sh.sha256
  sudo bash install.sh --release-tag v0.10.24-linux --platform linux
)
```

The installer:

1. Detects AMD64 or ARM64.
2. Installs Docker Engine, Docker Compose, `curl`, `jq` and required system
   packages when they are missing.
3. Downloads the matching precompiled runtime archive and verifies its
   published SHA-256 checksum.
4. Creates persistent Docker volumes for the node, wallet, pool and trading
   data.
5. Starts automatic release checks every 30 minutes on systems using systemd.

The application is installed under `/opt/5tratsmack`. Re-running a newer
verified installer updates the application while retaining its persistent
volumes.

## Addresses and ports

| Purpose | Address | Public exposure |
| --- | --- | --- |
| Web application | `http://HOST_IP:3015` | LAN only |
| Miner Stratum | `stratum+tcp://HOST_IP:57557` | LAN only |
| 5TRAT P2P | `HOST_IP:57555/TCP` | Optional inbound relay |
| Atomic swaps | outbound TCP `32326` | No inbound port forward required |
| Wallet/node RPC | `127.0.0.1:57576` | Never forward |

If automatic LAN-address discovery selects the wrong interface, download and
verify the installer as above and add `--bind-ip LAN_IP` to the install
command.

## Blockchain sharing

Every installation is already a full node. Outbound-only nodes synchronize and
validate normally, and still help their local wallet and miners. To accept
inbound peers, enable UPnP in the app or forward public TCP 57555 to this host.
Only one machine behind the same public IPv4 address can normally own that
external port.

Do not expose ports 3015, 57557 or 57576 to the public internet. They are not
required for blockchain replication.

## First-run checklist

1. Wait for blocks and headers to synchronize.
2. Create or restore the wallet.
3. Export an encrypted backup and verify that the file is readable.
4. Confirm the payout address before connecting miners.
5. Point miners at `stratum+tcp://HOST_IP:57557`.
