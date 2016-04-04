# yesno:
## Provide a yes-or-no prompt.
## If "yes", exit 0; if "no", exit nonzero.

yesno() {
  echo "$1"
  echo -n "(y/N)> "
  read result
  [[ "$result" == y* ]] || [[ "$result" == Y* ]]
  return $?
}
