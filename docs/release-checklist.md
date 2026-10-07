# Release checklist

This checklist distinguishes documentation publication from a future binary release or phone test.

## Documentation repository publication

- [x] The user authorized GitHub documentation publication under Doffi4/OnePlus13-SukiSU-SUSFS.
- [x] Public documentation is English; original docs/helpers have a scoped MIT license and upstream snapshots retain their notices.
- [x] Public checkpoint summaries exclude raw logs, serials, app/user UIDs and personal inventories.
- [x] The selected GitHub repository has been created.
- [ ] Publish the prepared documentation tree and verify the final remote commit.
- [ ] Check external upstream links and confirm redistribution terms for all selected snapshots.
- [ ] Keep OTA, stock images/modules, APK, private signing state and caches outside the published tree.
- [ ] Do not add a CI passing badge until a candidate-specific workflow has actually passed.

## Before a binary release

- [ ] Prepare complete corresponding sources and build inputs for each distributed binary; this handoff is not a complete source release.
- [ ] Validate a clean separate build environment with all pins, patches, public-certificate provenance and new local signing setup; private keys remain private.
- [ ] Repeat necessary build/audit/hash/installer checks for the exact release Image/ZIP.
- [ ] Obtain explicit authorization to publish binary artifacts and create release metadata only when a release actually exists.

## Before an explicitly approved phone test

- [ ] Refresh the read-only device/build/kernel/manager/daemon/active-slot checkpoint before making changes.
- [ ] Prepare a coordinated trusted manager/UAPI5 daemon transition, including assets/context; source-install behavior is not a runtime-success claim.
- [ ] Establish matching stock rollback inputs and a concrete recovery method for the current firmware/slot.
- [ ] Obtain a separate explicit decision for the exact device-changing operation immediately before it.
- [ ] Verify candidate boot, SELinux/FD, manager/root, module stages/mounts and radio/Wi-Fi/BT after the agreed transition.

Release notes must separate offline checks, observed runtime behavior and untested areas. Preserve builtin limits: main init scripts, CLI104/105 and debug mark remain unsupported. This checklist does not flash, uninstall apps, replace ksud or reboot a phone.
