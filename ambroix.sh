#!/bin/bash -i
# Bootstrap an Arch system.
## Scriptification of:
## https://wiki.archlinux.org/index.php/Hyper-V
## https://wiki.archlinux.org/index.php/Installation_guide.

usage() {
 PRRET="$?" 
  cat - <<EOS
Usage:
  $0 <platform> <user>
where <platform> is one of those found in platforms/.

Requires, on the host machine:
  which; mktemp; bash; and anything required from the platform-dependent
  "verify" hook.

See http://github.com/cceckman/distro for more complete usage information.
EOS
  exit "$PRRET"
}
if (( $# != 2 ))
then
  >&2 echo "Wrong number of arguments"
  usage
fi

source common/depend.fn.sh
depend mktemp || usage $?


