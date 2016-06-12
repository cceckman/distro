#!/bin/sh -i
# POSIX-compatible version of bash's 'select' builtin.
# Thanks to
# http://stackoverflow.com/questions/34256437/shell-bash-how-to-prompt-a-user-to-select-from-a-dynamically-populated-list
# for a start

function select() {
	while true; do
    i=0
    for var in "$@"
    do
      echo "$i) $var"
      i=$(($i + 1))
    done
    read -p "Select option: " na
    if [ "$n" -eq "$n" ] && [ "$n" -gt 0 ] && [ "$n" -le "$#" ]; then
      echo ${$i}
      break
    fi
  done  
}

count="$(wc -l server.list | cut -f 1 -d' ')"
n=""
while true; do
    read -p 'Select option: ' n
    # If $n is an integer between one and $count...
    if [ "$n" -eq "$n" ] && [ "$n" -gt 0 ] && [ "$n" -le "$count" ]; then
        break
    fi
done
value="$(sed -n "${n}p" server.list)"
echo "The user selected option number $n: '$value'".
