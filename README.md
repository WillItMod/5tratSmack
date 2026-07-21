# 5tratSmack

Public release, compatibility and issue-tracking home for 5tratSmack.

**[Read: What is 5TRAT?](docs/ABOUT-5TRAT.md)** explains why the coin was
created, how home mining works, the difference between the wallet's estimated
production cost and the completed-trade value, and how 5TRAT/DGB atomic swaps
work.

**[DEV release changelog](CHANGELOG.md)** records every 5tratumOS DEV
Community App Store version from the block-1000 launch line onwards.

The application is available through the 5tratumOS DEV Community App Store and
as a checksum-verified standalone Linux package for AMD64 and ARM64. The Linux
package is also used by the Proxmox helper. This repository intentionally
contains only public installers, compatibility metadata, checksums, release
notes and issue tracking; the private application source is kept in a separate
restricted repository.

## Install on Linux

The current standalone release is `v0.10.17-linux`. It detects AMD64 or ARM64,
installs Docker Engine and Docker Compose when required, verifies the selected
runtime archive and runs the complete node, wallet, pool, explorer and trading
application locally:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.10.17-linux
  curl -fSLO "$base/install.sh"
  curl -fSLO "$base/install.sh.sha256"
  sha256sum -c install.sh.sha256
  sudo bash install.sh --release-tag v0.10.17-linux --platform linux
)
```

Open `http://HOST_IP:3015` after installation. The Stratum endpoint is
`stratum+tcp://HOST_IP:57557`. Existing data is retained when the same
installation is updated, but an encrypted wallet backup should always be
created and tested first.

See **[Standalone Linux installation](docs/INSTALL-LINUX.md)** for supported
systems, ports, updating, custom bind addresses and public-node networking.

## Install a dedicated Proxmox node

Run this command as `root` on the Proxmox VE host. The helper creates an
unprivileged Debian LXC guest and installs Docker and 5tratSmack inside that
guest. It does not install either component on the Proxmox host:

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

The defaults are DHCP, the next free VMID, `vmbr0`, 80 GiB storage, four CPU
cores and 8 GiB memory. See **[Proxmox installation](docs/INSTALL-PROXMOX.md)**
for static-address, storage, bridge and resource examples.

## Is a separate public-node build required?

No. Every installation already contains a full validating 5TRAT node. It can
synchronize through outbound peers without any router changes and can become
an inbound community relay when TCP 57555 is reachable through UPnP or a manual
forward. A machine used only for replication can simply leave its wallet and
Stratum pool unused.

A separate node-only image would duplicate consensus packaging, testing and
updates without improving replication. The full application therefore remains
the supported public-node package. Never expose the wallet RPC, web interface
or Stratum port to the public internet merely to share the blockchain.

## Moving a prototype installation to the DEV community store

Do not install the DEV entry beside a running prototype. Both copies need the
same web, P2P, Stratum, and trade-mesh ports, so the second copy will fail to
start with an HTTP 400 from 5tratumOS.

The checked handover helper stops (but does not delete) the prototype
containers, copies its wallet, chain, pool, UI, and trading data into the
5tratumOS-managed app location, repairs a partial DEV install if one exists,
and leaves the prototype containers disabled as a rollback copy:

```bash
workdir="$(mktemp -d)"
cd "$workdir"
curl -fSLO https://raw.githubusercontent.com/WillItMod/5tratSmack/main/scripts/prototype-to-dev-store.sh
curl -fSLO https://raw.githubusercontent.com/WillItMod/5tratSmack/main/scripts/prototype-to-dev-store.sh.sha256
sha256sum -c prototype-to-dev-store.sh.sha256
sudo bash prototype-to-dev-store.sh
```

Existing private/keyed prototypes can switch to the same public update channel
without reinstalling their wallet:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.9.8-public-preview.1
  curl -fSLO "$base/prototype-bridge.sh"
  curl -fSLO "$base/prototype-bridge.sh.sha256"
  sha256sum -c prototype-bridge.sh.sha256
  sudo bash prototype-bridge.sh --release-tag v0.9.8-public-preview.1
)
```

If a public prototype inherited the DEV candidate's block-1000 mining gate,
run the checksum-verified prototype repair from an SSH session:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.9.8-public-preview.1
  curl -fSLO "$base/prototype-ungate.sh"
  curl -fSLO "$base/prototype-ungate.sh.sha256"
  sha256sum -c prototype-ungate.sh.sha256
  sudo bash prototype-ungate.sh
)
```

The helper refuses to run against the DEV build. It only changes the public
prototype's saved mining gate to zero and recreates its pool and web services;
wallet, blockchain, pool-history and trading volumes are not modified.

If a prototype pool repeatedly reports `Illegal instruction`, `core dumped`,
or exit code 132, install the baseline-safe pool image with this
checksum-verified repair:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.9.8-public-preview.1
  curl -fSLO "$base/prototype-portable-ckpool.sh"
  curl -fSLO "$base/prototype-portable-ckpool.sh.sha256"
  sha256sum -c prototype-portable-ckpool.sh.sha256
  sudo bash prototype-portable-ckpool.sh
)
```

This helper refuses the DEV build and preserves the prototype mining gate at
zero. It replaces and restarts only `ckpool`, observes live node/template
traffic for recurring CPU crashes, and automatically restores the prior image
if validation fails. All persistent volumes remain attached and unchanged.

## v0.9.8 public preview

- Rewrites the market book in plain buyer and seller language. A BUY bid now
  leads with the DGB offered and explicitly states how much 5TRAT the buyer
  wants; a SELL ask leads with the 5TRAT for sale and its full DGB value.
- Uses one consistent rate everywhere: DGB per 1 5TRAT.
- Replaces ambiguous selection controls with `BUY`, `SELL TO BUYER`, and
  `MANAGE YOUR ORDER` actions while preserving partial fills and concurrent
  BUY and SELL orders.
- Preserves the ungated prototype chain, wallets, balances, and live atomic
  orders during update.

## v0.9.7 public preview

- Rebuilds the mined-block archive from the full active chain after restoring a
  main-wallet backup, so historical wins return to the Blocks tab without
  changing the restored wallet or balance.
- Makes the history scanner start point explicit: full chain, installation
  date, or a selected month.
- Rescans a restored or registered 5TRAT trading address once from genesis,
  recovering historical unspent trading outputs.
- Retries DGB wallet activation after temporary DNS or network failures and
  keeps clearly marked cached wallet identity and balance data visible while
  the DGB backend is temporarily unavailable.
- Preserves prototype mining activation at height zero. The separately
  published DEV candidate remains gated until candidate block 1000.

## v0.9.6 public preview

- Replaces the permanent single-seed connection with address-fetch bootstrap,
  allowing a fresh node to learn and connect to the wider peer network.
- Selects the LAN listener from the host's actual default route instead of a
  Docker bridge or an unrelated VLAN address.
- Shows the discovered public IPv4 address even when UPnP is unavailable, but
  advertises it only after this exact host confirms either its own UPnP mapping
  or a genuinely public inbound peer.
- Handles shared-NAT installations safely: only the machine that owns the
  forwarded port becomes a public relay.

## v0.9.5 public preview

- Keeps the prototype web container on its routable edge network and publishes
  the 5tratumOS application port, preventing an internal-only network from
  producing a Bad Gateway page.
- Adds release checks for both prototype and DEV web routing.
- Remains an ungated prototype release: mining activation defaults to height
  zero and is independent of the block-1000 DEV Store candidate.

## v0.9.4 public preview

- Adds the release/licensing heartbeat used to identify the app as
  `5tratSmack` without exposing wallet, mining or personal data.
- Keeps prototype mining active at height zero while the independent
  DEV-store candidate waits for candidate block 1000.
- Adds checksum-verified ordinary Linux and Proxmox deployment instructions;
  the Proxmox helper selects suitable storage and cleans its temporary files.
- Preserves an existing prototype's selected bind address while moving it to
  the public update channel, including hosts with multiple LAN/VPN interfaces.

## v0.9.2 public preview

- Makes SmackBoard opt-in through a personalised coinbase name. Leaving the
  bundled `/5tratSmack/ Home miner` message unchanged keeps the miner off every
  leaderboard surface.
- Excludes the legacy `ckpool!/mined by WillItMod on 5tratumOS/` identity from
  rankings. These generic blocks remain available in the chain explorer.

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
