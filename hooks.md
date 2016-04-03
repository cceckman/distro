# Hooks
An Ambroix machine is built by selecting a platform
(e.g. VirtualBox, GCE, Raspberry Pi) and a user (e.g. cceckman),
and then running a script that iteratively builds the machine.
The platform- and user-dependent portions of the process are
invoked by calling auxiliary scripts, called "hooks".
A given platform may or may not have a given hook; e.g. a cloud VM may
not have a GUI installed.

## Context
The initial hooks are triggered on the remote machine, e.g. where the user is
sitting while setting up the Ambroix machine. Subsequent hooks are triggered


## Valid Hooks
- `prompt`: Gather necessary information: new user(s), keys / auth tokens, etc.
  Run from the *remote machine*.
- `image`: Prepares a machine for its first boot. Set up the image, make it
  reachable, and configure it to run the subsequent stages on its next boot.
  Expected to be run from the *remote machine*.
- `firstboot`: Run on the first (re)boot of the target machine. May
  install packages, reconfigure settings, etc. to establish reachability.
  Run from the *target machine*.
- `firstlogin`: Run at the user's first login. May prompt for additional
  information, e.g. new password, credentials, etc. before continuing on to
  subsequent steps. Run from the *target machine*.

