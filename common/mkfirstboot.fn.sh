# mkfirstboot: make a firstboot script.

mkfirstboot () {
  local REPO="$(cat common/repo)"

  cat <<-QDF
	output="/tmp/firstboot-output"

	echo "Hi! I'm running as \$(whoami) on \$(hostname)." >> \$output

	# Get source data from human
	ppromptfile=\$(mktemp)
	cat <<-EOF > \$ppromptfile
	$PLAT_PROMPT
	EOF

	upromptfile=\$(mktemp)
	cat <<-EOF > \$upromptfile
	$USER_PROMPT
	EOF


	# Install git
	pacman --noconfirm -Syyu git || {
	  echo "Could not install git!" >> \$output
	  exit 1
	}

	{
	  pushd /tmp && \
	    git clone http://$REPO -o distro \
	    && popd 
	} || {
	  echo "Could not clone repository ${REPO}!" >> \$output
	  exit 2 
	}


	# Run firstboot hooks
	export TGT_USER="$TGT_USER"
	export TGT_PLATFORM="$TGT_PLATFORM"
	cd /tmp/distro

  if git branch | grep -q $(hostname -a)
  then
    git checkout $(hostname -a)
  fi

	{
	  echo "Running hook 'firstboot' for platform '$TGT_PLATFORM'" >> \$output
	  platforms/$TGT_PLATFORM/firstboot \$ppromptfile \
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
	    users/$TGT_USER/firstboot \$upromptfile \
	      && echo "Hook 'firstboot' for user '$TGT_USER' complete." \
	      >> \$output
	  else
	    echo  "Skipping hook 'firstboot' for user '$TGT_USER'" >> \$output
	  fi
	} || {
	  ret=\$?
	  echo "'firstboot' for platform '$TGT_PLATFORM' exited with code \$ret; terminating." \
	    >> \$output
	  exit \$ret
	}
QDF
}
