ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

_AmbroixCompletePlatform() {
  echo $( compgen -W "$(ls $ABSOLUTE_PATH/platforms)" -- $1 )
}

_AmbroixCompleteUser() {
  echo $( compgen -W "$(ls $ABSOLUTE_PATH/users) ${USER}" -- $1 )
}

_AmbroixComplete() {
  # Sources:
  # http://brettterpstra.com/share/app_completions
  # http://tldp.org/LDP/abs/html/tabexpansion.html
  # And the absolute path bit from stackoverflow.
  local cur
  cur=${COMP_WORDS[COMP_CWORD]}

  case $COMP_CWORD in
   1)
    COMPREPLY=( $(_AmbroixCompletePlatform "$cur") )
    ;;
   2)
    COMPREPLY=( $(_AmbroixCompleteUser "$cur") )
    ;;
   *)
    COMPREPLY=()
    ;;
  esac

  return 0
}



complete -F _AmbroixComplete -o bashdefault *ambroix
