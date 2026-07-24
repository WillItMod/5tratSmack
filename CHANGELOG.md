# 5tratSmack DEV changelog

This file records the user-visible changes published through the 5tratumOS
DEV Community App Store. It begins with the block-1000 DEV launch line and
does not include the earlier private prototype builds.

The changelog describes behaviour, compatibility and migration effects. It
does not expose private credentials, signing material or restricted
application source.

## How this changelog is maintained

- Every new DEV-store version must receive an entry here before it is
  published.
- Entries are newest first and use the version shown by 5tratumOS.
- Each entry records fixes, user-visible changes, compatibility changes and
  any action required after updating.
- Published entries remain unchanged except for factual corrections.
- Release artefacts and public corresponding-source archives are linked where
  they exist.

## [0.10.26] - 2026-07-24

### Changed

- Promoted the tested 5tratSmack build to the MAIN Community Store as a
  release candidate while retaining the DEV-channel build for earlier access.
- Replaced remaining generic gold-five artwork with the approved 5TRAT coin
  roundel, using the cracked dark coin, gold `5`, blue left arc and pink right
  arc.
- Added compact Blue, Pink and Gold 5TRAT seals to mined-block history without
  crowding the block cards.
- Reworded the optional development contribution to explain that it helps fund
  the public seed nodes, market relays, explorers and other privately operated
  infrastructure that keeps the network available.

### Fixed

- Restored direct browser access for standalone Linux and Proxmox deployments.
  5tratumOS authentication remains in force when the app is installed through
  5tratumOS.

### Verified

- Built and published matching AMD64 and ARM64 application images.
- Rechecked the MAIN and DEV manifests, Compose files and runtime version
  markers.
- Smoke-tested the release-candidate application on the x86-64 5tratumOS test
  host without replacing its live wallet or blockchain data.

### Preserved

- Consensus rules, the five-minute block target, tiered block rewards, wallet
  balances, mining history, trade orders and atomic-swap data are unchanged.
- Updating does not reset or replace node data.

## [0.10.24] - 2026-07-24

### Added

- Moved native 5TRAT/DGB atomic swaps onto the established Komodo DeFi
  Framework public network, using public network ID `6133` and the maintained
  upstream KDF seed registry.
- Added the official 5TRAT coin configuration to the upstream
  [`GLEECBTC/coins` pull request #1903](https://github.com/GLEECBTC/coins/pull/1903).
  External KDF wallets can use that definition after the upstream maintainers
  merge it.

### Improved

- Ordinary app nodes now discover atomic-swap peers using outbound
  connections. A DEX port forward, DEX UPnP mapping and public app endpoint are
  no longer required.
- Unmatched buy and sell offers retain their order ID, price, remaining
  quantity and minimum fill during the network migration, then reappear on the
  public orderbook automatically.
- If an atomic swap is already in progress when the update arrives, KDF
  temporarily resumes the previous network so the swap can complete or refund.
  It restarts on the public network automatically after two clean settlement
  checks.
- The public VPS package now concentrates on chain seeds, explorers, Electrum
  access and the anonymous completed-trade tape. KDF discovery no longer
  depends on private 5TRAT DEX seed containers.

### Verified

- Completed a live 5TRAT/DGB atomic swap between two independent 5tratSmack
  nodes on KDF network ID `6133`.
- Moved a disposable live offer from the public network to the retired test
  network and back. The identical offer and UUID returned to the public
  orderbook, confirming that existing unmatched offers do not need deletion.
- Published and verified AMD64 and ARM64 application images.
- Published matching AMD64 and ARM64 standalone Linux runtimes and the
  Proxmox LXC installer. Standalone installations now join the same public KDF
  network and use the same safe offer/swap migration as the DEV package.

### Preserved

- Trading-wallet addresses, DGB and 5TRAT balances, encrypted recovery data,
  unmatched offers and completed trade history are retained.
- The mining wallet, blockchain, pool, mined-block history and consensus rules
  are unchanged.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.24-dev)
- [Linux and Proxmox release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.24-linux)

## [0.10.23] - 2026-07-23

### Fixed

- Fixed `My pool wins` attribution for delayed Pink and Gold rewards. Only
  coinbase output zero now identifies the miner that found the current block;
  a jackpot paid by the following block is no longer mistaken for another win.
- Existing local win archives are checked against the canonical chain after
  updating. False next-block entries are removed, duplicate block hashes are
  collapsed, and each genuine win is restored to its canonical Blue, Pink or
  Gold tier.
- The repair changes only the app's local win history. Blockchain data,
  rewards, wallet balances and coinbase transactions are unchanged.

### Added

- Added two independent DNS chain seeds, DEX entry points, Electrum services,
  explorers and anonymous completed-trade relays across OVH and Hetzner.
- Added the DNS seeds directly to 5TRAT Core as bootstrap hints. They introduce
  peers only; every node continues to validate the complete chain locally.
- Published the official 5TRAT coin site and linked it separately from the
  5tratumOS operating-system site.

### Improved

- Completed trades are now reported to both anonymous relays. Every node
  fetches, merges and deduplicates both tapes, so one unavailable VPS no longer
  removes network-wide trade history.
- The shared trade relays now permit read-only browser access for the live,
  completed-trade trend on the public coin site.

### Preserved

- Wallets, balances, blockchain data, pool history, orders and active swaps are
  retained during the update.
- Wallet addresses, usernames, node identities, passwords and private keys are
  never published to the completed-trade tape.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.23-dev)

## [0.10.22] - 2026-07-23

### Fixed

- Fixed Explorer block navigation so `Locate` moves only the horizontal
  active-chain strip. The surrounding Explorer page no longer shifts or
  remains clipped to the left.
- Empty, negative, fractional and oversized block heights are now rejected
  before any chain request is made.
- Fixed the Deep-Space Foundry mobile header so the app title and release
  marker wrap cleanly inside narrow phone and tablet screens.

### Verified

- Rechecked every main tab in the original, HashWatcher and Deep-Space
  Foundry themes at desktop, tablet and phone widths.
- Wallet, node, pool, trade, updater, UPnP and mining-activation regression
  tests continue to pass.

### Preserved

- Wallets, balances, blockchain data, pool history, orders and active swaps
  are retained during the update.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.22-dev)

## [0.10.21] - 2026-07-22

### Added

- Added the Deep-Space Foundry visual theme with physical control panels,
  amber instrumentation, restrained service wear and a green radar display.
- Added optional per-event sound controls for shares, proof tiers, accepted
  blocks, wallet movement, completed trades and system alerts. Audio remains
  muted until the user enables it.
- Added Clean Display mode to suppress transient activity messages and block
  celebrations while keeping live telemetry and important security dialogs.

### Fixed

- Restored immediate visibility of saved local pool wins in the Blocks and
  Explorer views. Slow chain enrichment now continues in the background
  instead of holding back the complete stored history.
- Matched Foundry navigation, controls and operational text to the original
  5tratSmack font family and sizing. Changing themes no longer changes the
  app's readable text scale.

### Preserved

- Wallets, balances, blockchain data, open orders and active swaps are
  retained during the update.
- The theme, sound and Clean Display changes affect presentation only.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.21-dev)

## [0.10.20] - 2026-07-22

### Added

- Added Silly as a fourth, deliberately excessive motion profile above
  Unhinged.
- Added meteor donuts, roaming props, black-hole eyes, faster miner orbits,
  event-aware comedy, extra laser theatre and an overblown block celebration.
- Added a permanently visible `Return to Chill` control while Silly is active.
  The Escape key provides a second instant exit.

### Preserved

- Silly changes presentation only. Blocks, balances, network difficulty,
  miner telemetry, wallet actions, orders and swaps remain factual.
- Chill retains its low-power rendering behaviour. Silly commentary also
  pauses while the browser tab is hidden.
- Smack and Unhinged keep their existing behaviour.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.20-dev)
- [Linux and Proxmox release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.20-linux)

## [0.10.19] - 2026-07-22

### Fixed

- Made Chill a genuine low-power mode. It now stops the miner-orbit rendering
  loop instead of repeatedly writing frozen positions at the browser refresh
  rate.
- Disabled continuous CSS animation and live glass-blur compositing in Chill.
- Paused the orbit renderer whenever the Mine page is not visible or the
  browser tab is in the background.
- Capped the normal Smack orbit renderer at 30 frames per second. Unhinged
  retains its full visual frame rate.
- Kept standalone Linux and Proxmox updates on the verified `-linux` release
  channel so a DEV Store release cannot be mistaken for a standalone runtime.

### Preserved

- Mining, wallet operations, chain validation, telemetry values, orders and
  swaps are unchanged.

- [DEV release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.19-dev)
- [Linux and Proxmox release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.19-linux)

## [0.10.18] - 2026-07-22

### Fixed

- Stopped an expired 5tratumOS sign-in from making the wallet or balance look
  empty.
- Added a clear private-data lock screen explaining that the wallet, balance
  and keys remain safe while the OS session is unavailable.
- Added a `Sign in and return` action that authenticates through 5tratumOS and
  returns directly to 5tratSmack.
- Preserved the existing standalone Linux and Proxmox behaviour. These builds
  do not depend on a 5tratumOS login.

### Recommended

- 5tratumOS 0.5.6 adds a separate trusted-device sign-in lifetime, set to 30
  days by default. Inactivity auto-lock and server sign-in lifetime can now be
  configured independently.

### Preserved

- Wallets, balances, chain data, existing orders and active swaps remain
  attached during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.18-dev)

## [0.10.17] - 2026-07-21

### Fixed

- Detected when 5tratSmack is opened on its direct application port instead of
  through the authenticated 5tratumOS app page.
- Replaced the misleading sign-in failure with an `Open OS updater` action
  that returns the user to the same app through 5tratumOS for secure update
  approval.
- Stopped direct-port sessions repeatedly sending unauthenticated Store sync
  requests to the application itself.

### Preserved

- Wallets, balances, chain data, existing orders and active swaps remain
  attached during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.17-dev)

## [0.10.16] - 2026-07-21

### Changed

- Replaced the hidden exchange-ratio editor with a direct `DGB per 1 5TRAT`
  price field.
- Added clearly labelled Competitive, Average and Peak price shortcuts when
  placing a buy or sell offer. No offer price is silently pre-filled.

### Fixed

- Prevented tiny extreme-price executions from distorting the completed-trade
  guide or flattening the Trade Pulse chart.
- Kept every valid completed trade visible in personal history while marking
  detected price outliers and excluding them only from guidance and chart
  scaling.
- Changed the recent completed-trade guide to a volume-weighted median and
  retained the robust completed-trade average for market context.

### Preserved

- Wallets, balances, chain data, existing orders and active swaps remain
  attached during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.16-dev)

## [0.10.15] - 2026-07-21

### Fixed

- Completed the in-app DEV updater repair for both ways 5tratumOS opens an
  application: inside the portal frame and directly at `/apps/5tratsmack/`.
- Bypassed the intentional app-path rewriter only for authenticated
  same-origin store operations. Normal 5tratSmack API requests remain scoped
  beneath the application path.

### Preserved

- Wallets, balances, chain data, existing orders and active swaps remain
  attached during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.15-dev)

## [0.10.14] - 2026-07-21

### Fixed

- Made the in-app Update button call the authenticated 5tratumOS parent store
  API instead of being rewritten back into the 5tratSmack app proxy.
- Kept the direct-port fallback for installations that are not opened through
  the normal 5tratumOS app frame.

### Changed

- Allowed up to eight independent live buy offers and eight independent live
  sell offers per wallet. Existing offers and active swaps no longer prevent
  another passive offer on the same side.

### Preserved

- Wallets, balances, chain data, existing orders and active swaps remain
  attached during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.14-dev)

## [0.10.13] - 2026-07-21

### Fixed

- Rebuilt mined-block history after an encrypted wallet restore using all
  legitimate mining payout addresses belonging to that wallet.
- Excluded ordinary incoming payments, orphaned coinbase transactions and the
  shared development-fund address from personal block-win history.
- Automatically repaired an empty historical scan without requiring another
  wallet restore; manual full/reset scans now use the same path.
- Made the in-app Update button perform a fresh DEV-store check and report
  `update available`, `current` or a visible error instead of silently doing
  nothing.

### Preserved

- Wallets, balances, chain data, open orders and trading state remain attached
  during the update.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.13-dev)

## [0.10.12] - 2026-07-21

### Added

- Progressive Active Chain navigation: load older blocks, move backward or
  forward, return to the live tip, or jump directly to a block height.

### Fixed

- Restored completed purchase and sale history when trading recovery records
  exceeded the previous response limit.
- Added bounded paging and more compact protocol data so long-running trading
  wallets can recover their activity reliably.

### Preserved

- Wallets, balances, open orders and the existing atomic-trade engine are
  unchanged.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.12-dev)

## [0.10.11] - 2026-07-21

### Added

- Split a trade into a read-only economics review followed by an explicit
  final authorisation.
- Showed the exact amount paid, amount received, reserved funds and offer
  terms before execution.
- Added completed-trade trend warnings at 20% and stronger warnings at 50%
  away from the established rate.

### Fixed

- Excluded unfilled bids and asks from the price-warning baseline; only
  completed trades influence it.
- Added a short final-button guard to prevent accidental double submission.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.11-dev)

## [0.10.10] - 2026-07-21

### Fixed

- Allowed a funded live offer to be accepted while other atomic swaps are
  still settling.
- Tracked each active swap independently instead of allowing one swap to hide
  another.
- Repaired the in-app updater through both the 5tratumOS proxy route and the
  direct application port.
- Removed the redundant DEV Community release banner from the main interface.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.10-dev)

## [0.10.9] - 2026-07-21

### Added

- Added an anonymous completed-trade tape. A market price is published only
  when the maker and taker records agree.
- Kept wallet addresses, usernames, node identities and open-order ownership
  out of the published trade record.

### Fixed

- Allowed users to accept a live sale while their own BUY offer remains open,
  and to accept a live bid while their own SELL offer remains open.
- Protected funds reserved by existing orders and used only genuinely
  unreserved balances for new activity.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.9-dev)

## [0.10.8] - 2026-07-20

### Changed

- Routed in-app updates through the authenticated 5tratumOS DEV Community App
  Store and disabled the legacy prototype updater in DEV installations.
- Added a checksum-verified prototype-to-DEV handover helper that preserves
  wallet, chain, pool, interface and trading volumes and retains the stopped
  prototype as a rollback copy.

### Fixed

- Avoided the HTTP 400 and port conflicts caused by installing the DEV app
  beside a running prototype.

### Compatibility

- Published AMD64 and ARM64 images; the block-1000 activation boundary was
  unchanged.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.8-dev)

## [0.10.7] - 2026-07-20

### Fixed

- Rebuilt the bundled solo pool for a baseline AMD64 CPU target so older
  systems no longer crash with `Illegal instruction`, `core dumped` or exit
  code 132.

### Preserved

- Consensus, rewards, wallets, persistent data and the block-1000 activation
  boundary were unchanged.

[Release artefacts](https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.7-dev)

## [0.10.6] - 2026-07-20

### Changed

- Rewrote the market book in plain buyer and seller language.
- Standardised every displayed rate as `DGB per 1 5TRAT`.
- Made BUY offers lead with the DGB offered and the amount of 5TRAT wanted.
- Made SELL offers lead with the amount of 5TRAT for sale and its full DGB
  value.
- Replaced ambiguous controls with `BUY`, `SELL TO BUYER` and
  `MANAGE YOUR ORDER` while retaining partial fills.

## [0.10.5] - 2026-07-20

### Fixed

- Started restored-wallet block-history reconstruction from the full chain
  instead of the installation-time cutoff.
- Repaired restored wallet activation and mining payout selection after an
  encrypted import.
- Improved recovery of historical trading-wallet outputs after restore.

> Note: the broader multi-address history repair was completed in 0.10.13.

## [0.10.4] - 2026-07-20

### Fixed

- Repaired ownership of migrated public-node and trading-mesh mapper state so
  helper services could update their status after a prototype-to-DEV move.
- Limited the permission repair to the required state files while preserving
  persistent application data.

## [0.10.3] - 2026-07-20

### Fixed

- Corrected public-IP discovery and peer fan-out for newly installed nodes.
- Replaced a permanent dependency on one bootstrap connection with seed-based
  address discovery so nodes can learn and connect to the wider peer set.
- Improved UPnP and manual-forward status reporting, including the LAN listener
  and restart-required state.

## [0.10.2] - 2026-07-20

### Fixed

- Restored the externally reachable DEV Stratum route on TCP port 57557.
- Attached the bundled solo pool to the correct internal network while keeping
  its chain connection isolated.
- Added release verification for the published Stratum mapping.

## [0.10.1] - 2026-07-20

### Fixed

- Repaired 5tratumOS reverse-proxy routing that caused a fresh DEV installation
  to show `Bad Gateway`.
- Connected the web application to the required internal edge network without
  exposing node RPC or wallet services.

## [0.10.0-dev.1] - 2026-07-20

### Added

- Introduced the first 5tratumOS DEV Community App Store release line.
- Activated public mining from candidate block 1000: an accepted tip at block
  999 opens the block-1000 template automatically, with no block-1001 delay.
- Shipped the self-contained 5TRAT node, encrypted wallet, solo pool, explorer
  and atomic 5TRAT/DGB trading components.
- Enabled the shared trading mesh for fresh DEV installations.
- Published AMD64 and ARM64 container support and corresponding public GPL
  source archives where required.

### Safety

- Fresh installations began without a pre-filled personal payout address.
- Chain, wallet, pool and trading data were placed in persistent volumes so
  application updates do not reset them.

## Public release records

- [5tratSmack GitHub releases](https://github.com/WillItMod/5tratSmack/releases)
- [5tratumOS DEV Community Store history](https://github.com/WillItMod/umbrel-dev-community-store/commits/main/)

[0.10.19]: https://github.com/WillItMod/5tratSmack/compare/v0.10.18-dev...v0.10.19-dev
[0.10.18]: https://github.com/WillItMod/5tratSmack/compare/v0.10.17-dev...v0.10.18-dev
[0.10.17]: https://github.com/WillItMod/5tratSmack/compare/v0.10.16-dev...v0.10.17-dev
[0.10.16]: https://github.com/WillItMod/5tratSmack/compare/v0.10.15-dev...v0.10.16-dev
[0.10.15]: https://github.com/WillItMod/5tratSmack/compare/v0.10.14-dev...v0.10.15-dev
[0.10.14]: https://github.com/WillItMod/5tratSmack/compare/v0.10.13-dev...v0.10.14-dev
[0.10.13]: https://github.com/WillItMod/5tratSmack/compare/v0.10.12-dev...v0.10.13-dev
[0.10.12]: https://github.com/WillItMod/5tratSmack/compare/v0.10.11-dev...v0.10.12-dev
[0.10.11]: https://github.com/WillItMod/5tratSmack/compare/v0.10.10-dev...v0.10.11-dev
[0.10.10]: https://github.com/WillItMod/5tratSmack/compare/v0.10.9-dev...v0.10.10-dev
[0.10.9]: https://github.com/WillItMod/5tratSmack/compare/v0.10.8-dev...v0.10.9-dev
[0.10.8]: https://github.com/WillItMod/5tratSmack/compare/v0.10.7-dev...v0.10.8-dev
[0.10.7]: https://github.com/WillItMod/5tratSmack/releases/tag/v0.10.7-dev
[0.10.6]: https://github.com/WillItMod/umbrel-dev-community-store/commit/9b34b2f
[0.10.5]: https://github.com/WillItMod/umbrel-dev-community-store/commit/51d018c
[0.10.4]: https://github.com/WillItMod/umbrel-dev-community-store/commit/6fc6c36
[0.10.3]: https://github.com/WillItMod/umbrel-dev-community-store/commit/51a9a7d
[0.10.2]: https://github.com/WillItMod/umbrel-dev-community-store/commit/96f2be9
[0.10.1]: https://github.com/WillItMod/umbrel-dev-community-store/commit/a10f5a7
[0.10.0-dev.1]: https://github.com/WillItMod/umbrel-dev-community-store/commit/936ae3f
