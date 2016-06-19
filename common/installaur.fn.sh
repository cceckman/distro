#!/bin/bash
# Install yaourt.

installyaourt() {
  for repo in package-query yaourt
  do
  	pushd /tmp/
  	git clone https://aur.archlinux.org/${repo}.git && cd ${repo}
  	makepkg -sri --noconfirm
  	popd
  done
}

installaur() {
  installyaourt || return $?
  yaourt --noconfirm -S "$@" || {
    ret=$?
    echo "Could not install AUR packages!"
    return $ret
  }
}
