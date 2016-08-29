#!/bin/sh
# Set up LXDM as the display service, i3 as WM.

guisetup() {
  sed -i 's/^.*numlock=.*$/numlock=0/' /etc/lxdm/lxdm.conf
  sed -i "s:^.*[^a-z]session=.*\$:session=$(which i3):" /etc/lxdm/lxdm.conf
  systemctl enable lxdm.service
}
