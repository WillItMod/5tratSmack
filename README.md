# 5tratSmack

Public release, compatibility and issue-tracking home for 5tratSmack.

The application is still in private prototype testing and is not yet
available through the 5tratumOS DEV store. This repository intentionally does
not contain the private application source. Public installers, compatibility
manifests, checksums and release notes will live here when a build is approved
for wider testing.

## Architectures

The release pipeline targets:

| Platform | Docker platform | Status |
| --- | --- | --- |
| Modern Intel and AMD processors | `linux/amd64` | Build and smoke test |
| 64-bit ARM systems, including Raspberry Pi 4/5 | `linux/arm64` | Build and smoke test |

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
