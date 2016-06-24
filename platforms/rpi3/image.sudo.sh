#!/bin/bash
# run-as-root portion of setting up image.

# TODO trap
set -e

IMGPATH="/tmp/download/arch-rpi.tar.gz"

# Download in background
mkdir -p /tmp/download
curl -sLo $IMGPATH \
  http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz &

disk="$1"
hostname="$2"

echo "Setting up disk and filesystems..."
# Per https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3
fdisk "$disk" <<EOF
o
p
n
p
1

+100M
t
c
n
p
2


w
EOF

# TODO use different directories here.
mkdir -p /mnt/boot
mkdir -p /mnt/root
mkfs.vfat "${disk}1" && mount "${disk}1" /mnt/boot
mkfs.ext4 "${disk}2" && mount  "${disk}2" /mnt/root

echo "Waiting for image download to complete..."
wait
echo "Done!"

echo "Copying image to /mnt/root..."
bsdtar -xpf $IMGPATH -C /mnt/root
echo "Done!"

# TODO install qemu, etc., run some commands within chroot.
# https://wiki.archlinux.org/index.php/Raspberry_Pi#QEMU_chroot

echo "Setting up first-boot behavior..."
common/image.setfirstboot.sh /mnt/root
echo "Done!"

echo "Copying to /mnt/boot..."
mv /mnt/root/boot/* /mnt/boot
echo "Done!"

echo "Syncing filesystem to media..."
sync
echo "Done!"

echo "Unmounting..."
umount /mnt/boot
umount /mnt/root
echo "Done!"

echo "Checking filesystems..."
{
  fsck "${disk}1" && fsck "${disk}2" \
} || {
  echo "Filesystem check failed!"
  exit 9
}
