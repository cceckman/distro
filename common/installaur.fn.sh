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
  for f in $(ls common/aur)
  do
    cat common/aur/$f | fmt | xargs yaourt --noconfirm -S || {
      ret=$?
      echo "Could not install AUR package!"
      return $ret
    }
  done
}
