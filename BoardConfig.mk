# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := KIRIN
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := generic
TARGET_BOARD_PLATFORM_GPU := kirin

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

BOARD_KERNEL_CMDLINE :=

# Header values match stock PAR recovery_ramdisk (EMUI 9.0.0.186):
# base 0x10000000 + mkbootimg defaults -> kaddr 0x10008000, raddr 0x11000000
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x8000 --ramdisk_offset 0x01000000 --tags_offset 0x0100

# phony empty kernel to satisfy build system, but this device does not
# include a kernel in the recovery image -- flash to recovery_ramdisk
TARGET_PREBUILT_KERNEL := device/huawei/par/dummykernel

BOARD_BOOTIMAGE_PARTITION_SIZE := 25165824
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4487905280
BOARD_USERDATAIMAGE_PARTITION_SIZE := 119663493120
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_HAS_NO_SELECT_BUTTON := true

TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN
TW_DEVICE_VERSION := PAR
# Match the stock Huawei recovery reset semantics: formatting Data also erases
# emulated internal storage (/data/media), instead of TWRP's usual media-preserving wipe.
TW_FACTORY_RESET_FORMAT_DATA := true
# Avoid probing or mounting freshly formatted userdata until the next boot.
TW_SKIP_DATA_POST_FORMAT_MOUNT := true
# Huawei's 4.9 F2FS driver spins while importing the NAT-bits table emitted by
# newer f2fs-tools. Keep the older checkpoint layout used by stock userdata.
TW_F2FS_DISABLE_NAT_BITS := true
# A blank FBE filesystem must be initialized by Android vold; TWRP must not
# pre-create a plaintext /data/media hierarchy after Format Data.
TW_FBE_DATA_MEDIA_INIT_BY_SYSTEM := true
BOARD_SUPPRESS_SECURE_ERASE := true
RECOVERY_SDCARD_ON_DATA := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd_backlight0/brightness
TW_NO_HAPTICS := true
TW_NO_SCREEN_BLANK := true
TW_USE_TOOLBOX := true
TW_DEFAULT_BRIGHTNESS := "2048"
TW_CUSTOM_BATTERY_PATH := /sys/class/power_supply/Battery
TW_CUSTOM_BATTERY_FALLBACK_PATH := /sys/class/power_supply/battery
# Device crashes if /sbin/modprobe is present so this is needed:
BOARD_CUSTOM_BOOTIMG_MK := device/huawei/par/custombootimg.mk
# fscrypt v1 (FBE) decrypt + keymaster HAL (kernel has /dev/tc_ns_client)
TW_INCLUDE_CRYPTO := true

# Keep recovery-side diagnostics available while bringing up the proprietary
# TEE/keymaster stack.  Starting logd before the HALs also preserves their
# loader and registration errors instead of reducing every failure to exit(1).
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true
TWRP_INCLUDE_STRACE := true

# Recovery sepolicy additions: EMUI9 vendor types (tee/teecd, keymaster,
# gatekeeper, tc_ns_client) are missing from the AOSP recovery policy, so
# vendor services cannot exec. par_decrypt.te re-declares them permissive.
BOARD_VENDOR_SEPOLICY_DIRS += device/huawei/par/sepolicy
# eng build; neverallow would reject the permissive domains otherwise
SELINUX_IGNORE_NEVERALLOWS := true
