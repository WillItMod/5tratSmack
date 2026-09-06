# Check that you can recover both wallets

5tratSmack 0.11.13 adds a quarterly reminder for the main wallet and the separate
trading wallet. Open **Check my backups** in the reminder, or **Wallet recovery
checks & backup options** at the bottom of the app. Check each wallet in turn.

1. Find your saved current wallet password and use **Test password**.
2. Choose your saved recovery file and enter the passphrase used to encrypt that
   file. Leave the passphrase blank if the file is unencrypted.
3. Select **Read back and verify**. The app checks that the file opens and matches
   the selected wallet. This does not restore a wallet or move any coins.

Both steps must pass before that wallet's quarterly check is complete. The next
calendar-quarter reminder is in January, April, July or October. **Remind me in
7 days** delays the reminder without marking the check complete. The reminder
appears when you use the app; it does not send email.

## Make a fresh recovery file

The same screen offers two choices:

- **Encrypt with a passphrase — recommended.** Choose and confirm a backup
  passphrase of at least 12 characters. Store it separately from the file. It can
  differ from the wallet password and does not change that password.
- **No encryption.** This requires acknowledging that anyone with the file can
  spend the coins without a password. Keep the file offline in a secure place;
  do not email it, upload it or leave it in a shared Downloads folder.

Enter the current password for the selected wallet, prepare the file, and click
**Save**. Then select that downloaded file in the read-back step. Preparing or
saving a file alone never completes the quarterly check.

The main wallet uses a `.5tratwallet` file. The trading wallet uses a `.json`
recovery file covering both its 5TRAT and DGB trading keys. These wallets need
separate backups.

## If a password is forgotten

A working recovery file can restore the wallet with a new wallet/control
password. An encrypted recovery file still needs its own backup passphrase.
An unencrypted file needs no backup passphrase. The main wallet's original
password is required to create the recovery export while you still know it.
The app cannot bypass a lost encrypted main-wallet password without usable
recovery material.

Native `.dat` backups retain the original Core wallet encryption and password.
They are different from recovery exports and are not accepted by this read-back
check. Keep existing native backups, and create a `.5tratwallet` recovery file to
use the new check. Older encrypted files retain the passphrase they had when
exported, even after a wallet password changes.

Use 5tratSmack 0.11.13 or later to restore an unencrypted `.5tratwallet` file;
older browser wallets may support only encrypted files. Main-wallet replacement
still requires explicit confirmation. Trading restore remains blocked while
funds, pending funds, orders or active swaps remain in the trading wallet.
