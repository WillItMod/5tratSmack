# 5TRAT Komodo DeFi Framework integration

5TRAT already uses the open-source Komodo DeFi Framework (KDF) for native,
non-custodial 5TRAT/DGB atomic swaps inside 5tratSmack. The files in this
directory are the public listing package for making the same coin available in
external KDF-based wallets such as Komodo Wallet.

This is an integration project, not an exchange listing announcement. No
custodian, bridge token or wrapped asset is involved. A successful swap moves
native DGB on the DigiByte chain and native 5TRAT on the 5TRAT chain.

## Proven

- KDF recognises the 5TRAT CashAddr format and BCH fork-ID signatures.
- 5TRAT and DGB activate together in the same KDF process.
- Discovery, negotiation, payment, redemption and completion have succeeded.
- A completed 1 5TRAT / 500 DGB KDF v2 swap is documented in
  [`swap-proofs/5TRAT-DGB-b0c14cea.json`](swap-proofs/5TRAT-DGB-b0c14cea.json).
- The public chain source is available at
  [WillItMod/5trat-core](https://github.com/WillItMod/5trat-core).

## Public-listing checklist

| Requirement | State |
| --- | --- |
| Public coin configuration | Prepared in [`coins-entry.json`](coins-entry.json) |
| 512 px PNG icon | Prepared in [`icons/5TRAT.png`](icons/5TRAT.png) |
| Public source | Live |
| Public explorers | Two live, synced and independently hosted endpoints |
| Electrum server 1 | Live on OVH: TCP and secure WebSocket |
| Electrum server 2 | Live on Hetzner: TCP and secure WebSocket, backed by an independent full node |
| BIP44/SLIP-0044 path | `m/44'/5755'`; [registration PR submitted](https://github.com/satoshilabs/slips/pull/2037) |
| Public five-transaction swap proof | Captured with live explorer links |
| Upstream `KomodoPlatform/coins` PR | [Draft #17 submitted](https://github.com/KomodoPlatform/coins/pull/17); independent second ingress is now live |

The two public Electrum services now run on independent full nodes, public IPs
and hosting providers. The OVH and Hetzner hosts each expose their own
read-only explorer and Electrum index while independently validating the same
5TRAT chain. Losing either provider no longer removes every public wallet
ingress.

| Provider | Chain / DEX | Electrum | Explorer |
| --- | --- | --- | --- |
| OVH | `seed1.5trat.net:57555` / `dex1.5trat.net:30808` | `electrum1.5trat.net:50001` | `https://explorer1.5trat.net/explorer/` |
| Hetzner | `seed2.5trat.net:57555` / `dex2.5trat.net:30808` | `electrum2.5trat.net:50001` | `https://explorer2.5trat.net/explorer/` |

## Network parameters

| Parameter | Value |
| --- | --- |
| Ticker | `5TRAT` |
| Name | 5tratum Coin |
| Chain type | UTXO, SHA-256d |
| Decimals | 8 |
| Address format | CashAddr with network prefix `5trat` |
| P2PKH / P2SH / WIF | 125 / 80 / 181 |
| Signature fork ID | `0x40` |
| SegWit | No |
| Average block time | 300 seconds |
| Recommended confirmations | 12 |
| Coinbase maturity | 100 |
| Mainnet P2P / RPC | 57555 / 57576 |
| Genesis | `af4973599946fbe8c350eae4ff51ba9fbe3fc00fa07e8413b869874ee1be8310` |

## Security boundary

The explorer and Electrum services are read-only indexes. They do not receive
wallet passphrases, seed phrases, private keys or access to the 5tratSmack
wallet. KDF swaps remain peer-to-peer and each side signs only its own native
chain transactions.
