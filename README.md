# TWRP device tree for Huawei nova 3 (PAR)

## What this repository implements

Community TWRP 3.7.0_9 device support for Huawei nova 3 (`PAR`, Kirin 970). It builds only the
`recovery_ramdisk` image and is not an official TeamWin release.

Huawei proprietary files are not included. Builders must extract them from
their own EMUI 9 firmware with `scripts/extract-proprietary.sh`.

## Upstream source base

- TeamWin provides the TWRP Android 9 recovery source.
- The device tree is ported from TeamWin's Huawei Charlotte work by Daniel
  Storozhev and LuK1337 / Łukasz Patron.
- VistaSlayer (`Bakoubak`) and anael.rst's Mate 10 ALP work was used as a
  Huawei/Kirin 970 recovery reference.
- Android 13 decryption uses AOSP Keymaster helper code from a revision
  recorded under Janis Danisevskis's authorship, and the NAT-bits patch is
  based on F2FS tools.

These items remain upstream or reference work. yukino1111 maintains the PAR
port, local compatibility bridge, and device-specific fixes described in
`ATTRIBUTION.md`.

## Disclaimer

This is a personal project shared as-is and is not an official TeamWin build.
Flashing a custom recovery can cause data loss, boot failure, or a bricked
device. You accept all risk and responsibility for flashing and recovery. No
warranty, updates, porting, or device-recovery support is provided. If you need
different behavior, use the published source and build instructions to compile
it yourself.

## Compatibility and tested setup

- Device: Huawei nova 3 (`PAR`).
- Verified stock firmware base: EMUI `9.0.0.187`.
- An EMUI 9 base is required; other major base versions are not supported.
- On-device testing was performed only with the AlphaDroid GSI released from
  [android_gsi_alphadroid_par](https://github.com/yukino1111/android_gsi_alphadroid_par).

## Build

Place this tree at `device/huawei/par` in a TWRP 9 checkout, apply the patches
under `patches/`, then run:

```bash
device/huawei/par/scripts/extract-proprietary.sh /path/to/extracted-emui-root
source build/envsetup.sh
lunch omni_par-eng
mka recoveryimage
```

## Installation

Make sure the bootloader is unlocked, enter Fastboot mode, and flash the
release image only to `recovery_ramdisk`:

```bash
fastboot flash recovery_ramdisk RECOVERY_RAMDISK.img
fastboot reboot
```

After rebooting, disconnect the USB cable and hold Volume Up to enter TWRP.
Booting with the cable connected enters eRecovery. Never flash this image to
`erecovery_ramdisk`.

## License

See [`ATTRIBUTION.md`](ATTRIBUTION.md) and [`LICENSES.md`](LICENSES.md). Huawei
proprietary files are excluded from Git.

## Acknowledgements

- [Team Win Recovery Project](https://github.com/TeamWin/android_bootable_recovery)
  and its contributors provide the recovery code.
- This device tree is derived primarily from TeamWin's
  [Huawei Charlotte device tree](https://github.com/TeamWin/android_device_huawei_charlotte),
  whose inherited history credits Daniel Storozhev and LuK1337 / Łukasz Patron.
- Huawei/Kirin 970 recovery bring-up also referenced VistaSlayer's (`Bakoubak`)
  device work and anael.rst's
  [Mate 10 ALP TWRP work](https://xdaforums.com/t/recovery-dev-twrp-3-7-0-for-huawei-mate-10-alp-emui-9-1.4638352/)
  and [device tree](https://github.com/Bakoubak/twrp_device_huawei_alp).
- Android 13 decryption support includes AOSP Keymaster helper code from a
  revision recorded under Janis Danisevskis's authorship.
