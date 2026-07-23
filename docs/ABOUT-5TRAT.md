# 5TRAT: a coin built for home miners

5TRAT is an independent SHA-256d proof-of-work cryptocurrency created within
the 5tratumOS community. It was built to bring identity, entertainment and
genuine solo-mining excitement back to home mining.

The idea came from a simple problem. On established networks, a home miner can
run for months or years without finding a block. Conventional pools solve that
by dividing rewards into tiny share payments, but the excitement of actually
finding a block disappears.

5TRAT keeps the block. When a miner finds one, it is permanently recorded on
the public blockchain with its block number, proof quality and optional
coinbase name. The result is closer to a community mining game while remaining
a real proof-of-work blockchain with ordinary wallets, transactions, nodes and
independently validated consensus.

## Designed around home mining

The network targets one block approximately every five minutes. Difficulty
adjusts after every block to respond to changes in total network hashrate and
maintain that target over time.

Mining remains probabilistic. A miner providing more work has a greater chance
of finding a block, but smaller miners still have a genuine chance.
Home-miner focused does not mean every miner receives an equal payout. It means
the network, app and experience have been designed around independently
operated home hardware rather than industrial pool accounting.

Every accepted proof is classified automatically:

- **Blue:** an accepted block.
- **Pink:** at least four times stronger than required.
- **Gold:** at least twelve times stronger than required.

From block 280, a block pays 4.75 5TRAT immediately. Pink adds a 0.50 5TRAT
bonus in the following block, while Gold adds 2.00 5TRAT. Across the
probabilities, the long-term expected reward remains 5.00 5TRAT per block.

The proof tiers are not separate mining lanes. They all use the same blockchain
target, and network difficulty affects all miners and all tiers together.

## Who decides what 5TRAT is worth?

Nobody assigns an official price to 5TRAT.

Network difficulty, electricity consumption and mining effort do not create a
guaranteed market price. The people buying, selling, mining and holding the
coin decide what they are prepared to exchange for it.

The app therefore displays two deliberately separate figures.

### Wallet: estimated production cost

The value shown in the wallet is an estimated electricity break-even cost. It
is not a sale price and it is not a promise that the coins can be sold for that
amount.

The estimate uses:

- The miner's current observed hashrate, or its configured fallback.
- A standard efficiency assumption of 14 joules per terahash.
- The current network difficulty.
- The user's selected electricity tariff.
- The expected number of 5TRAT produced statistically at those conditions.

The calculation is:

```text
Estimated power = hashrate x 14 J/TH

Daily electricity cost =
    estimated power x 24 hours x electricity tariff

Estimated cost per 5TRAT =
    daily electricity cost / statistically expected coins per day
```

The wallet total multiplies that estimated cost per coin by the wallet's
spendable, pending and immature balance.

This is an indicative production-cost estimate based on current conditions.
It is not a historical measurement of the exact electricity used by a
particular machine, and it does not include hardware purchase cost, cooling,
maintenance or other expenses.

### Trade: observed exchange value

The Trade page represents what people are actually exchanging through
completed 5TRAT/DGB atomic swaps.

The recommended trading rate is derived only from completed swaps corroborated
by both sides of a trade. Open bids and asks do not set the guide price,
preventing an unrealistic order from moving the displayed trend before any
trade has occurred.

Each participant signs an anonymous receipt describing the completed amount,
rate and direction. A trade joins the public tape only when its maker and taker
receipts agree. Two independent relays operated on different hosting providers
serve the same public format, and 5tratSmack merges and deduplicates their
results. Wallet addresses, node identities, usernames, passphrases and private
keys are never published to the tape.

The displayed trend is not a fixed exchange rate, guaranteed price or project
valuation. It can rise or fall as new trades complete, and individual buyers
and sellers remain free to publish a different rate. The current live figure
is shown in 5tratSmack and on [5trat.com](https://5trat.com); it is calculated
from completed trades rather than a price chosen by the project.

## How 5TRAT and DGB trading works

5tratSmack includes an isolated atomic-swap trading wallet for 5TRAT and
DigiByte. This is separate from the main mining wallet.

A buyer funds the DGB side and chooses an available 5TRAT offer. A seller moves
5TRAT into the trading wallet and publishes or accepts an order. Orders can be
partially filled, allowing several people to purchase portions of a larger
listing.

Completed swaps exchange 5TRAT and DGB directly across their respective
blockchains. The process does not require 5tratSmack to take custody of both
sides through a conventional central exchange account.

The trading-wallet recovery backup remains essential. The mining wallet and
trading wallet are separate, and both must be backed up securely.

## Public, open and driven by its users

5TRAT began as a home-mining experiment, but its blockchain is public and
independently replicated by participating nodes. Wallet transactions, blocks,
proof tiers and coinbase messages are inspectable on-chain.

The project does not dictate the market price. Miners decide whether the
reward is worth their energy. Buyers decide what they will pay. Sellers decide
what they will accept. Nodes independently validate the chain under publicly
inspectable consensus rules.

It is a coin created for home miners, secured by their contributed work and
valued through voluntary exchange.

It is your hash, your block and your coin.

## Public network services

The public network is deliberately spread across two providers:

| Service | Primary | Secondary |
| --- | --- | --- |
| Chain seed | `seed1.5trat.net:57555` | `seed2.5trat.net:57555` |
| DEX peer | `dex1.5trat.net:30808` | `dex2.5trat.net:30808` |
| Electrum | `electrum1.5trat.net:50001` | `electrum2.5trat.net:50001` |
| Explorer | `https://explorer1.5trat.net/explorer/` | `https://explorer2.5trat.net/explorer/` |
| Completed-trade relay | `https://market1.5trat.net/trade-tape/` | `https://market2.5trat.net/trade-tape/` |

These are bootstrap and read-only discovery services, not authorities over the
chain. Every full node validates consensus independently and continues using
peer discovery after bootstrap.
