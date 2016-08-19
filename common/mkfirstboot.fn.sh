# mkfirstboot: make a firstboot script.

_REPO="$(cat common/repo)"

mkfirstboot () {
  local REPO="$_REPO"

  cat <<QDF
#!/bin/bash
output="/tmp/firstboot-output"

echo "Hi! I'm running as \$(whoami) on \$(hostname)." >> \$output

# Get source data from human
ppromptfile=\$(mktemp)
cat <<-EOF > \$ppromptfile
$(cat $PLAT_PROMPT | sed 's/EOF/XOF/g')
EOF

upromptfile=\$(mktemp)
cat <<-EOF > \$upromptfile
$(cat $USER_PROMPT | sed 's/EOF/XOF/g')
EOF

# *really* wait for the network to be up.
fping -r 20 google.com >> \$output || {
  echo "Could not reach the network!" >> \&output
  exit 1
}

# Install git
pacman --noconfirm -Syyu git >> \$output || {
  echo "Could not install git!" >> \$output
  exit 1
}

{
  pushd /tmp && \
    git clone http://$REPO -o distro >> \$output \
    && popd 
} || {
  echo "Could not clone repository ${REPO}!" >> \$output
  exit 2 
}


# Run firstboot hooks
export TGT_USER="$TGT_USER"
export TGT_PLATFORM="$TGT_PLATFORM"
cd /tmp/distro

if git branch --remote | grep -q "\$(hostname -s)"
then
  git checkout \$(hostname -s) >> \$output
fi

{
  echo "Running hook 'firstboot' for platform '$TGT_PLATFORM'" >> \$output
  platforms/$TGT_PLATFORM/firstboot \$ppromptfile 2>&1 >> \$output \
    && echo "Hook 'firstboot' for platform '$TGT_PLATFORM' complete." \
    >> \$output
} || {
  ret=\$?
  echo "'firstboot' for platform '$TGT_PLATFORM' exited with code \$ret; terminating." \
    >> \$output
  exit \$ret
}

{
  if [ -f users/$TGT_USER/firstboot ] && [ -x users/$TGT_USER/firstboot ]
  then
    echo "Running hook 'firstboot' for user '$TGT_USER'" >> \$output
    users/$TGT_USER/firstboot \$upromptfile 2>&1 >>\$output \
      && echo "Hook 'firstboot' for user '$TGT_USER' complete." \
      >> \$output
  else
    echo  "Skipping hook 'firstboot' for user '$TGT_USER'" >> \$output
  fi
} || {
  ret=\$?
  echo "'firstboot' for user '$TGT_USER' exited with code \$ret; terminating." \
    >> \$output
  exit \$ret
}
QDF
}
