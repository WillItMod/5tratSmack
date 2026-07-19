# Supported architectures

5tratSmack uses a single architecture-neutral Compose definition and
multi-platform OCI image indexes.

## AMD64

`linux/amd64` covers modern 64-bit AMD and Intel CPUs. The KDF swap service
uses the checksum-pinned upstream Linux release binary.

## ARM64

`linux/arm64` covers AArch64 servers and recent single-board computers. The
node, pool, helper and UI build directly from their normal source trees. Since
the upstream KDF project does not currently publish a Linux ARM64 archive, the
release pipeline compiles it from the same pinned upstream source commit used
by the AMD64 release.

An ARM release is not considered ready until:

1. All images report an ARM64 architecture.
2. The node passes startup and RPC smoke tests.
3. CKPool serves a valid Stratum subscription.
4. The KDF binary starts and reports the pinned version.
5. An ARM-generated block is accepted by an AMD64 node and vice versa.

Use an SSD rather than an SD card for blockchain data.
