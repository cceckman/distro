# Functions for hard dependencies.

## Use `which` to find a program, and exit if not found.
depend() {
  bin="$1"
  # Need which to find other programs..
  if ! which -v >/dev/null 2>&1 
  then
    >&2 echo "'which' not found in \$PATH"
    return 1
  fi

  if ! which "$bin" >/dev/null 2>&1 
  then
    >&2 echo "'$bin' not found in \$PATH"
    return 2
  fi
}
