#!/bin/bash
set -x
pacman --noconfirm -Sy unzip
curl -Lo distro.zip https://github.com/cceckman/distro/archive/master.zip
unzip distro.zip && cd distro-master
echo "Now run ./ambroix <platform> <user> to begin!"
