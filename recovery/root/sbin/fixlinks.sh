#!/sbin/sh

if [ -d /dev/block/platform/ff3c0000.ufs ]; then
    echo "using ufs"
    ln -sf /dev/block/platform/ff3c0000.ufs /dev/block/bootdevice
else
    echo "using emmc"
    ln -sf /dev/block/platform/hi_mci.0 /dev/block/bootdevice
fi

# Creates new symlinks without the _a in them since this device does
# not really have boot slots (silly Huawei...)

for f in /dev/block/bootdevice/by-name/*_a
do
	ln -sf $f ${f%??}
done

# --- PAR decrypt support -------------------------------------------------
# /system (ramdisk) is a symlink to /system_root/system; the GSI rootfs has
# bin -> /system/bin which loops back, breaking execve of /system/bin/linker64.
# TWRP itself uses /system_root (ro.twrp.sar=true), so /system can be replaced
# with a minimal tree that provides TWRP's Android 9 linker64, ld.config.txt
# (so EMUI9 vendor blobs can load /sbin libs) and the VINTF manifest symlink.

wait_for_dev() {
    local dev="$1"
    local i=0
    while [ ! -e "$dev" ] && [ "$i" -lt 50 ]; do
        sleep 0.1
        i=$((i + 1))
    done
}

# Replace /system (symlink or dir) with our minimal tree.
if [ -L /system ]; then
    rm /system
elif [ -d /system ] && [ "$(ls -A /system 2>/dev/null)" != "" ]; then
    rm -rf /system
fi
mkdir -p /system/bin /system/etc/vintf /system/lib64/hw
chmod 755 /system /system/bin /system/etc /system/etc/vintf /system/lib64 /system/lib64/hw
ln -sf /sbin/linker64 /system/bin/linker64
cp /sbin/ld.config.txt /system/etc/ld.config.txt
chmod 644 /sbin/ld.config.txt /system/etc/ld.config.txt
ln -sf /vendor/etc/vintf/manifest.xml /system/etc/vintf/manifest.xml

# Ensure /vendor is mounted (teecd + HAL blobs live there); TWRP also mounts
# it, but the decrypt services start immediately after this script completes.
wait_for_dev /dev/block/bootdevice/by-name/vendor
if ! mount | grep -q ' /vendor '; then
    mount -t ext4 -o ro /dev/block/bootdevice/by-name/vendor /vendor 2>/dev/null
fi
# keymaster/gatekeeper run as user system. Their /system/bin/linker64
# interpreter and recovery libraries must therefore be traversable/readable.
chmod 755 /sbin /sbin/linker64 /sbin/*.so /sbin/wait-for-service.sh \
    /sbin/tee_auth_daemon 2>/dev/null

# TEE secure storage partition MUST be mounted BEFORE teecd starts
# (AGENT_FS depends on it). Mount first, then signal service start.
wait_for_dev /dev/block/bootdevice/by-name/secure_storage
mkdir -p /sec_storage
if ! mount | grep -q ' /sec_storage '; then
    mount -t ext4 -o nosuid,nodev,noatime,data=journal,context=u:object_r:teecd_data_file:s0 \
        /dev/block/bootdevice/by-name/secure_storage /sec_storage 2>/dev/null \
        || mount -t ext4 -o nosuid,nodev,noatime \
        /dev/block/bootdevice/by-name/secure_storage /sec_storage 2>/dev/null
fi
chown root root /sec_storage
chmod 600 /sec_storage
