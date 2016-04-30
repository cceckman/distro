# kvpf: key-value promptfile. Super simple.

pfset(){
  file="$1"
  key="$2"
  value="$3"
  if [[ "$key" == *:* ]]
  then
    >&2 echo "Key for set '$key' cannot have colons! Please fix your code, or don't use kvpf.fn!"
    exit -127
  fi
  sed --in-place '' --expression ":^${key}\::!p" "$file" >/dev/null 2>&1
  echo "${key}:${value}" >> "$file"
}

pfget() {
  file="$1"
  key="$2"
  if [[ "$key" == *:* ]]
  then
    >&2 echo "Key for get '$key' cannot have colons! Please fix, or don't use kvpf.fn!"
    exit -126
  fi
  grep -Pho "(?<=^${key}:).*$" "$file" || {  
    >&2 echo "Did not find key '$key' in promptfile '$file'."
    return 5
  }
}
