# Source attribution

This repository combines an inherited TeamWin device-tree history with local
PAR integration and a small set of recovery-source patches. Importing,
rebasing, or adapting upstream code does not transfer authorship.

## Upstream and reference work

| Area | Original author or project | Use in this repository |
| --- | --- | --- |
| Huawei Charlotte device tree | Daniel Storozhev, LuK1337 / Łukasz Patron, and TeamWin contributors | Direct Git history before the PAR port; original author metadata is preserved |
| TWRP recovery source | TeamWin contributors | Base for all files changed by `patches/bootable-recovery/` |
| Android Keymaster helper headers | Android Open Source Project; the imported revision records Janis Danisevskis | Apache-2.0 helper code used by the Android 13 FBE compatibility layer in `0001-par-recovery-features.patch` |
| Huawei Mate 10 ALP recovery reference | VistaSlayer (`Bakoubak`) and anael.rst | Bring-up reference; not presented as yukino1111's original device work |
| F2FS tools | F2FS contributors | Base for the NAT-bits compatibility patch |

The inherited Charlotte commits remain authored by their original authors in
Git. Existing file copyright notices are authoritative for copied AOSP and
TeamWin code.

## PAR-specific work

The following porting and device fixes are maintained by yukino1111:

- the PAR device conversion, stock recovery header/layout matching, and
  `recovery_ramdisk`-only build integration;
- Keymaster/Gatekeeper/TEE wiring and the local Keystore2/Keymaster 3 bridge
  needed for Android 13 FBE decryption;
- ABX header detection, dynamic USB OTG discovery, FBE wipe/MTP handling, and
  Linux 4.9 F2FS NAT-bits compatibility;
- PAR haptics and the correction of the default backup list.

These local changes do not claim authorship of TeamWin, AOSP, F2FS, the
Charlotte device tree, or the referenced Mate 10 ALP work.
