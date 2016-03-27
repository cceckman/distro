# Common setup for platform hooks.

if (( $# != 1 ))
then
    echo "Wrong number of arguments. Provide a single hook to invoke."
    exit 1
fi

HOOKS[${#HOOKS}]="listhooks"
listhooks() {
    echo ${HOOKS[*]}
}

for i in `seq 0 ${#HOOKS}`
do
    if [[ "$1" == ${HOOKS[$i]} ]] 
    then
        ${HOOKS[$i]}
        exit $?
    fi
done

echo "Hook $1 not found!"
exit 2
