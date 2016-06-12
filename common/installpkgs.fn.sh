# Grab packages from the standard list. Must include git.
installpkgs() {
  for f in $(ls common/pkgs)
  do
    cat common/pkgs/$f | sed '/^\s*/d' | xargs pacman --noconfirm -S || {
      ret=$?
      echo "Could not install packages!"
      return $ret
    }
  done
}
