#!/bin/bash -i
# Set up the chroot of the new VM.

set -e
for sig in INT TERM EXIT; do 
  trap "echo 'Encountered an error! Dropping into bash.' && bash; [[ $sig == EXIT ]] || (trap - $sig EXIT; kill -$sig $$)" $sig 
done

set -x

# Set up VirtualBox.
systemctl enable vboxservice.service

vbox_modules="vboxguest vboxsf vboxvideo"
sed -i "s/^MODULES=\"/MODULES=\"$vbox_modules/" /etc/mkinitcpio.conf

mkinitcpio -p linux

grub-install --target=i386-pc --recheck /dev/sda

echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT splash iomem=relaxed"' >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Ensure that dhcpcd starts next time around
systemctl enable dhcpcd.service

trap - EXIT
