# 5tratSmack

Public release, compatibility and issue-tracking home for 5tratSmack.

The application is available as a public-preview direct Linux installation and
as a block-1000 pre-launch candidate in the 5tratumOS DEV store. This
repository intentionally contains only public installers, compatibility
metadata, checksums, release notes and issue tracking; the private application
source is kept in a separate restricted repository.

## Install on Linux or 5tratumOS

The installer detects 64-bit AMD/Intel and ARM systems automatically. Download
both files and verify the checksum before running it:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.9.8-public-preview.1
  curl -fSLO "$base/install.sh"
  curl -fSLO "$base/install.sh.sha256"
  sha256sum -c install.sh.sha256
  sudo bash install.sh --release-tag v0.9.8-public-preview.1
)
```

No installation key or GitHub account is required. Existing wallet and chain
data are preserved during an update, but a verified encrypted wallet backup is
still strongly recommended before installation.

Prototype installations are explicitly ungated: their installer preserves
`FIVETRAT_MINING_ACTIVATION_HEIGHT=0`. The separately staged 5tratumOS DEV-store
candidate hard-codes height 1000 and is published only through the DEV store.

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

## Create a dedicated Proxmox node

Run this on the Proxmox VE host as `root`. It creates an unprivileged Debian
12/13 LXC and installs 5tratSmack inside the guest; it does not install the
application or Docker on the Proxmox host:

```bash
(
  set -Eeuo pipefail
  workdir="$(mktemp -d)"
  trap 'rm -rf "$workdir"' EXIT
  cd "$workdir"
  base=https://github.com/WillItMod/5tratSmack/releases/download/v0.9.8-public-preview.1
  curl -fSLO "$base/proxmox-helper.sh"
  curl -fSLO "$base/proxmox-helper.sh.sha256"
  sha256sum -c proxmox-helper.sh.sha256
  bash proxmox-helper.sh --release-tag v0.9.8-public-preview.1
)
```

The helper defaults to a dedicated unprivileged LXC using DHCP and selects a
suitable active Proxmox storage that supports LXC root disks. Run
`bash proxmox-helper.sh --help` to see static-address, storage, bridge and
resource options. The command runs in a temporary subshell, so it returns to
the original directory and removes its downloaded installer files when it
finishes.

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
