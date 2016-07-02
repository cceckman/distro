#!/bin/bash
# Call against the root directory of an image

f=common/mkfirstboot.fn.sh; source $f || { >&2 echo "$f not found!" && exit 2; }

pushd $1

servicepath=/etc/systemd/system
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

popd
