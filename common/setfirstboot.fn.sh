#!/bin/bash
# Call against the root directory of an image to set up the first-boot script.

f=common/mkfirstboot.fn.sh; source $f || { >&2 echo "$f not found!" && exit 2; }

setfirstboot() {

  MOUNT="$1"
  binpath=/usr/bin/firstboot.sh
  mkdir -p "${MOUNT}/etc/systemd/system"
  cat <<EOF >${MOUNT}/etc/systemd/system/ambroix.service
[Unit]
Description=Distribution first-boot
Requires=network-online.target
After=network-online.target
Support=http://cceckman.com/r/distro

[Service]
Type=oneshot
ExecStart=$binpath

[Install]
WantedBy=multi-user.target
EOF

  mkfirstboot > "${MOUNT}${binpath}"
  chmod +x "${MOUNT}${binpath}"

  # Set it to run
  mkdir ${MOUNT}/etc/systemd/system-preset/
  cat <<EOF >${MOUNT}/etc/systemd/system-preset/50-ambroix.preset
enable ambroix.service
EOF

  # Above only works with 'systemctl preset'; link as well
  ln -s /etc/systemd/system/ambroix.service ${MOUNT}/etc/systemd/system/multi-user.target.wants/ambroix.service
}
