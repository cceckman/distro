# err: Write to stderr.
source common/depend.fn.sh
depend tput

# Color support shamelessly stolen from stackoverflow:
# https://unix.stackexchange.com/questions/9957/how-to-check-if-bash-can-print-colors
if [ -t 1 ] && [ -n "$(tput colors)"] && [ "$(tput colors)" -ge 8 ]
then
  bold="$(tput bold)"
	underline="$(tput smul)"
	standout="$(tput smso)"
	normal="$(tput sgr0)"
	black="$(tput setaf 0)"
	red="$(tput setaf 1)"
	green="$(tput setaf 2)"
	yellow="$(tput setaf 3)"
	blue="$(tput setaf 4)"
	magenta="$(tput setaf 5)"
	cyan="$(tput setaf 6)"
	white="$(tput setaf 7)"

	# support color
	err() {
		>&2 echo -n "${red}Error:${normal} "
		>&2 echo "$@"
	}
else
  # Don't support color
	err() {
		>&2 echo -n "Error: "
		>&2 echo "$@"
	}
fi

