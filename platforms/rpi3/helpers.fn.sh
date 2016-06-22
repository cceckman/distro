# Helper functions for GCE scripts.

PLATFORM='gce'

_GcloudOrErr(){
  results=$( "$@" ) || {
    ret=$?
    err "Error code $ret return from command '$1'"
    return $ret
  }
  echo "$results"
  return $ret
}
# Prints just the name of the entity.
_gcfmt="--format csv[no-heading](name)"


