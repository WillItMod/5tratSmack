# 5tratSmack

Public release, compatibility and issue-tracking home for 5tratSmack.

The application is available as a public-preview, direct Linux installation.
It is **not yet available through the 5tratumOS DEV store**. This repository
intentionally contains only public installers, compatibility metadata,
checksums, release notes and issue tracking; the private application source is
kept in a separate restricted repository.

## Install on Linux or 5tratumOS

The installer detects 64-bit AMD/Intel and ARM systems automatically. Download
both files and verify the checksum before running it:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  curl -fSLO https://github.com/WillItMod/5tratSmack/releases/download/v0.9.1-public-preview.1/install.sh
  curl -fSLO https://github.com/WillItMod/5tratSmack/releases/download/v0.9.1-public-preview.1/install.sh.sha256
  sha256sum -c install.sh.sha256
  sudo bash install.sh
)
```

No installation key or GitHub account is required. Existing wallet and chain
data are preserved during an update, but a verified encrypted wallet backup is
still strongly recommended before installation.

## Create a dedicated Proxmox node

Run this on the Proxmox VE host as `root`. It creates an unprivileged Debian 12
LXC and installs 5tratSmack inside the guest; it does not install the
application or Docker on the Proxmox host:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  curl -fSLO https://github.com/WillItMod/5tratSmack/releases/download/v0.9.1-public-preview.1/proxmox-helper.sh
  curl -fSLO https://github.com/WillItMod/5tratSmack/releases/download/v0.9.1-public-preview.1/proxmox-helper.sh.sha256
  sha256sum -c proxmox-helper.sh.sha256
  bash proxmox-helper.sh
)
```

The helper defaults to a dedicated unprivileged LXC using DHCP. Run
`bash proxmox-helper.sh --help` to see static-address, storage, bridge and
resource options. The command runs in a temporary subshell, so it returns to
the original directory and removes its downloaded installer files when it
finishes.

## v0.9.1 public preview

- Corrects BUY-order book quantities so DGB quote volume is never presented as
  5TRAT availability. A bid for 1 5TRAT at 450 DGB now shows 1 5TRAT
  available, a 1 5TRAT minimum and a 450 DGB total.
- Keeps the v0.9.0 SmackBoard, three-byte extranonce, concurrent BUY/SELL and
  independent electricity-tariff improvements.

## v0.9.0 public preview

- Adds SmackBoard, a leaderboard calculated by each node from accepted
  active-chain blocks. Rankings use the public coinbase name, block wins,
  Blue/Pink/Gold proof mix and strongest target multiple.
- Moves the bundled solo pool to the agreed three-byte extranonce2 default.
  This changes the Stratum job protocol only; it does not reset the chain,
  wallets or balances.
- Allows one live BUY order and one live SELL order at the same time. Duplicate
  orders on the same side remain blocked in Quick Trade, and active atomic
  settlements still pause new orders.
- Lets users save their electricity tariff independently of the optional
  fallback hashrate, including arbitrary positive decimal hashrates.

Coinbase names are public labels rather than authenticated accounts. Two
miners using the same name deliberately share one leaderboard row. Historical
hashrate cannot be reconstructed from the blockchain, so SmackBoard does not
invent it; a node may show local worker attribution only when its own pool
captured the winning share.

## Architectures

The release pipeline targets:

| Platform | Docker platform | Status |
| --- | --- | --- |
| Modern Intel and AMD processors | `linux/amd64` | Public preview |
| 64-bit ARM systems, including Raspberry Pi 4/5 | `linux/arm64` | Public preview |

ARM32 is not supported.

Every approved release is expected to contain the node, bundled solo pool,
wallet UI, UPnP helper and isolated swap engine for both supported
architectures. Docker selects the correct image automatically.

## Repositories

- This repository: public release metadata, documentation and issues.
- [`WillItMod/5trat-core`](https://github.com/WillItMod/5trat-core): public
  blockchain protocol and node source.
- Private application source and signing infrastructure remain in a separate
  restricted repository.

## Security

Do not post wallet backups, private keys, recovery words, passwords, public IP
addresses or unredacted diagnostic bundles in an issue. See
[SECURITY.md](SECURITY.md) before reporting a security problem.
