# Status · 2026-10-07

**Offline kernel binary audit: PASS. UAPI5 phone transition: NOT READY.**

After the reported reset, a fresh read-only checkpoint established the current phone state. Earlier device snapshots were not assumed to remain valid. The new candidate and its audited ZIP were not modified; no install, flash, reboot, daemon execution or module-script execution was performed during this checkpoint.

| Area | Verified state or boundary |
|---|---|
| Device / firmware | CPH2653 / OP5D55L1; CPH2653_16.0.10.501(EX01) |
| Current root access | Confirmed by a read-only root identity check |
| Current kernel | GNU Build ID ba2c2d9b2a34b2ced8d64ff579998772af44131b matches the previous trust501 baseline |
| Current manager | Normal com.sukisu.ultra, versionCode40900; expected supplied spoofed package absent |
| Current daemon | On-disk ksud equals the current manager APK daemon; string 4.2.0-1-g904c60d1 (uapi:2) |
| Current Fix4.1 NVBK portion | Alias and loop backing observed applied; this does not certify all radio behavior |
| New candidate | 40959/UAPI5 builtin compatibility backport; offline audit passed, phone runtime untested |

Current daemon SHA256: 9f57222b06222f461bbb69b24e40a293e34708eeb7b1bbb065110651f7b9c991. The [public checkpoint summary](../provenance/runtime-checkpoint.json) omits device serials, user/app UIDs, app/module inventories, private paths and raw logs.

The known candidate GNU Build ID is 388fd5878edc89a3fd3fd22b9c786f2426b403b9. Build ID distinguishes these recorded builds; it is not a cryptographic proof of every byte of a running Image. The phone is on the previous baseline, not this UAPI5 candidate.

MainActivity automatically installs the daemon only when isManager is true and manager/kernel UAPI versions match. The inspected standard ksud Install dispatch does not itself require matching UAPI; it updates the daemon, assets, resetprop and context. This source behavior is not proof of a successful installation on this phone. Copying only the daemon would not reproduce the standard install path.

Current UAPI2 userspace would skip boot stages when paired with kernel UAPI5. The exact manager/daemon transition must be prepared before testing the candidate. Trusting an APK signature does not guarantee selection of that manager when multiple trusted packages coexist. No uninstall/install or daemon replacement command is provided here.

Unsupported builtin/main features: custom modules.rc, /data/adb/initrc.d or module init/*.rc processing, CPU/UTS CLI104/105 and debug mark. Standard shell boot-stage contracts were checked; candidate runtime boot, SELinux/FD transfer, manager selection, module mounts and radio/Wi-Fi/BT remain untested.

Any device-changing action requires a separate explicit decision for the concrete operation. Kernel rebuilding is not justified by this userspace transition checkpoint.
