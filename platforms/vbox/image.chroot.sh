#!/bin/bash -i
# Set up the chroot of the new VM.

f=common/err.fn.sh; source $f || { >&2 echo "$f not found!" && exit 2; }
f=common/mkfirstboot.fn.sh; source $f || { >&2 echo "$f not found!" && exit 2; }

set -e
for sig in INT TERM EXIT; do
  trap "echo 'Encountered an error! Dropping into bash. && bash; [[ $sig == EXIT ]] || (trap - $sig EXIT; kill -$sig $$)" $sig 
done

set -x

# Set up VirtualBox.
pacman-key --refresh-keys
pacman --noconfirm -S linux-headers virtualbox-guest-utils
systemctl enable vboxservice.service


vbox_modules="vboxguest vboxsf vboxvideo"
sed -i "s/^MODULES=\"/MODULES=\"$vbox_modules/" /etc/mkinitcpio.conf

mkinitcpio -p linux

# Install GRUB
pacman --noconfirm -S grub
grub-install --target=i386-pc --recheck /dev/sda

echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT splash iomem=relaxed"' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Ensure that dhcpcd starts next time around
systemctl enable dhcpcd@$(ip link | grep -Po '(en|eth)[^: ]*(?=:)').service


# TODO Auto-start the firstboot upon reboot.
servicepath=/etc/systemd/system/
binpath=/usr/bin/firstboot.sh
mkdir $servicepath
cat <<EOF >$servicepath/ambroix.service
[Unit]
Description=Set up Ambroix install (http://cceckman.com/r/distro)
Requires=network-online.target

[Service]
Type=oneshot
ExecStart=$binpath

EOF
mkfirstboot > $binpath
chmod +x $binpath
