#!/bin/bash
# Call against the root directory of an image to set up the first-boot script.

f=common/mkfirstboot.fn.sh; source $f || { >&2 echo "$f not found!" && exit 2; }

MOUNT="$1"

binpath=/usr/bin/firstboot.sh
mkdir "${MOUNT}${servicepath}"
cat <<EOF >${MOUNT}/etc/systemd/system/ambroix.service
[Unit]
Description=Set up Ambroix install (http://cceckman.com/r/distro)
Requires=network.target
[Service]
Type=oneshot
ExecStart=$binpath
EOF

mkfirstboot > "${MOUNT}${binpath}"
chmod +x "${MOUNT}${binpath}"

mkdir ${MOUNT}/etc/systemd/system-preset/
cat <<EOF >${MOUNT}/etc/systemd/system-preset/50-ambroix.preset
enable ambroix.service
EOF
