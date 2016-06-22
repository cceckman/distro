#!/bin/bash
# run-as-root portion of setting up image.

# TODO trap
set -e

# Download in background
mkdir /tmp/download
curl -Lo /tmp/download/arch-rpi.tar.gz \
  http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz &

disk="$1"
hostname="$2"

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


mkdir -p /mnt/boot
mkdir -p /mnt/root
mkfs.vfat "${disk}1" && mount "${disk}1" /mnt/boot
mkfs.ext4 "${disk}2" && mount  "${disk}2" /mnt/root

wait
# Wait for download to complete
bsdtar -xpf /tmp/download/arch-rpi.tar.gz -C /mnt/root

mv /mnt/root/boot/* /mnt/boot

common/image.setfirstboot.sh /mnt/root

sync
