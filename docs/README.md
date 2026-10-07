# Documentation

[Project README](../README.md)

| Document | Purpose |
|---|---|
| [Status](status.md) | Current read-only checkpoint, candidate state and transition limits |
| [Source provenance](provenance.md) | Pins, patches and additional source inputs |
| [Build and cache](build.md) | Actual native target, recorded scripts and cache preservation |
| [Audit boundaries](audit.md) | Module CRCs, signatures, UAPI and KMI evidence |
| [Artifacts](artifacts.md) | Image/ZIP identity; binaries are held separately |
| [Guarded AnyKernel3](installer.md) | Device/slot guards and offline repack limits |
| [Release checklist](release-checklist.md) | Publication and first device-test gates |
| [Credits and licenses](../NOTICE.md) | Original-file MIT scope and upstream terms |

Machine-readable references: [source pins](../provenance/source-pins.json), [OEM manifest](../provenance/source-manifest.xml), [status](../provenance/status.json), [redacted runtime checkpoint](../provenance/runtime-checkpoint.json) and [evidence inventory](../provenance/evidence-index.json). Audit summaries retain original-file hashes; machine-local output paths and certificate file references have been removed.
