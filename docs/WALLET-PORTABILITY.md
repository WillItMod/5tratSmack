# Portable 5TRAT wallet format

The browser wallet at [5trat.com/wallet](https://5trat.com/wallet) and
5tratSmack use the same encrypted `.5tratwallet` recovery envelope.

This is a portability format, not a hosted account. The website does not
receive or retain the recovery words, private keys or passwords. The native
application imports the envelope locally and performs a full chain rescan
before presenting recovered history.

## Deterministic wallet

- Recovery phrase: BIP39, 12 English words
- Coin type: `5755`
- Account path: `m/44'/5755'/0'`
- External addresses: `m/44'/5755'/0'/0/index`
- Change addresses: `m/44'/5755'/0'/1/index`
- Address encoding: CashAddr using the `5trat` prefix

The format stores the account-level external and change private descriptors,
not a plaintext recovery phrase. A restored browser wallet can therefore
continue deriving the same receiving and change addresses.

## Encrypted envelope

The exported JSON envelope contains:

- `format`: `5trat-portable-wallet`
- `version`: `1`
- password-based key derivation parameters
- AES-256-GCM cipher parameters
- encrypted wallet payload
- creation timestamp and public format metadata

Encryption uses PBKDF2-HMAC-SHA256 with a random 16-byte salt and 600,000
iterations. The derived 256-bit key encrypts the payload using AES-256-GCM and
a random 12-byte nonce. The password is not stored in the file.

## Moving between the website and 5tratSmack

### Browser to application

1. Create or recover the wallet at `5trat.com/wallet`.
2. Export an encrypted `.5tratwallet` file.
3. In 5tratSmack, open Wallet and choose the portable browser-wallet import.
4. Enter the portable-backup password and choose a new on-chain wallet
   passphrase.
5. Allow the application to complete its full chain rescan.

### Application to browser

1. In 5tratSmack, open Wallet and export a portable browser-wallet backup.
2. Enter the existing on-chain wallet passphrase and a separate portable-file
   password.
3. On `5trat.com/wallet`, import that `.5tratwallet` file.

The legacy full wallet backup remains the preferred disaster-recovery backup
for the native application because it also preserves wallet metadata and
application-oriented recovery behaviour. Keep both backups encrypted and test
them before relying on either one.

## Security notes

- Reloading or closing the browser wallet clears unlocked key material from
  page memory.
- Browser storage, cookies and analytics are not used for keys or recovery
  words.
- Public explorers are used only for balances, history and UTXOs.
- Transactions are assembled and signed locally before a signed transaction is
  broadcast through a public Electrum endpoint.
- A forgotten backup password cannot be recovered.
- Verify the destination, amount and fee before signing.

The browser wallet is a public preview. For larger balances, use the full
5tratSmack node wallet and retain independently tested encrypted backups.
