#!/bin/bash
# Per https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3,
# set up an SD card with an ARM Arch image.


if (( $# != 1 ))
then
  echo "Please provide the SD card /dev/ device as argument 1."
  exit 1
fi

dev="$1"

if df -h | grep $dev
then
  echo "$dev appears to be in use; aborting."
  exit 2
fi

for sig in INT TERM EXIT; do
  trap "echo 'Encountered an error! Dropping into bash.' && bash; [[ $sig == EXIT ]] || (trap - $sig EXIT; kill -$sig $$)" $sig 
done
set -e
set -x

# Set up filesystem

parted --script $dev mklabel msdos &&
  parted --script --align optimal $dev -- mkpart primary fat32 0% 100M set 1 lba &&
  parted --script --align optimal $dev -- mkpart primary ext4 100M 100%

mkdir -p /tmp/rpi && cd /tmp/rpi

mkfs.vfat ${dev}1
mkdir -p boot
mount ${dev}1 boot

mkfs.ext4 ${dev}2
mkdir -p root
mount ${dev}2 root

# Get base image
URL="http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz"
curl -o arch-arm-latest.tar.gz -L $URL
bsdtar -xpf arch-arm-latest.tar.gz -C root
sync

mv root/boot/* boot

mkdir -p root/root/.ssh
cat $(eval echo ~${SUDO_USER})/.ssh/id_ed25519.pub >> root/root/.ssh/authorized_keys

# TODO: Copy over arch-install.sh, invoke on first boot.

umount boot root

set +e
set +x

# Now you can login as alarm@alarmpi
echo "Pull out the SD card, boot up the RPi, and put its IP here: "
read rpiip
echo "Press enter to continue..."
ssh -o PasswordAuthentication=yes root@${rpiip}
