### Preface
The below describes the design of a system that **does not exist**. Yet.
See #1 for plans and progress.

# Ambroix Installer
An Ambroix machine is built by running the [ambroix.sh](ambroix.sh) script with
two parameters, `platform` and `user`. `platform` specifies the architecture
targetted, e.g. a VM on [GCE](http://cloud.google.com/compute) or in
[VirtualBox](http://virtualbox.org); or a physical device such as a
[Raspberry Pi](http://raspberrypi.org). `user` specifies the name of the
first user to create when setting up the machine.

The Ambroix script then runs through a number of [stages](#stages);
at each stage, it calls two [hooks](#hooks), one for the platform, then one
for the user. The script eventually directs the user to continue setup on
the target platform.

## Main script
The main script is [ambroix.sh](ambroix.sh). It should be invoked as

```shell
ambroix.sh &lt;platform&gt; &lt;user&gt;
```

## Stages
- `verify`: Verify that this platform can run on this host.[^sane] This may
  include checking for the presence of `tar`, `curl`, a binary toolchain, etc.
  It may also attempt to install these dependencies.
  Run on the **host**.
- `prompt`: Gather necessary information: new user(s), keys / auth tokens, etc.
  from the user.  
  Run on the **host**.
- `image`: Prepares a machine for its first boot. Set up the image, make it
  reachable, and configure it to run the subsequent stages on its next boot.
  Run on the **host**.
- `firstboot`: Run on the first (re)boot of the target. May
  install packages, reconfigure settings, etc. to establish reachability.
  Run on the **target**.
- `firstlogin`: Run at the user's first login. May prompt for additional
  information, e.g. new password, credentials, etc. before continuing on to
  subsequent steps.
  Run on the **target**.

### Host and target
The initial hooks are triggered on the **host** machine, i.e. where the user is
sitting while setting up the Ambroix machine. Subsequent hooks are triggered on
the **target**, i.e. the machine being installed.

In some cases, "host" and "target" represent different incarnations of the same
physical device: e.g. booted from a LiveCD versus booted from an installed disk.

Some platforms may do all their work on the host; others may do some work on
the host and other work once the target boots.

## Hooks
Hooks are scripts (or binaries) named after the stages. At each stage, the main
script triggers the relevant hook for the platform, then the hook for the user.

### Promptfiles
Hooks are invoked as

```shell
platforms/&lt;platform&gt;/&lt;stage&gt; &lt;platform promptfile path&gt;
```
or
```shell
users/&lt;username&gt;/&lt;stage&gt; &lt;user promptfile path&gt;
```

`promptfile path` is the path to some file that the hook can understand, read
from, and write to; it's opaque to system. Usually, it's a file that the
`prompt` hook fills with information from the user, and subsequent stages use
to tweak their behavior.

### Common code
Since many platforms will share the same code, the [common](common/) directory
contains common scripts/programs, libraries, and configuration.

### Platform Hooks
Platform hooks are located in the [platforms](platforms/) directory; each
platform gets a subdirectory (which defines the platform's name.) Each platform
**must** support each stage, i.e. have a hook for the stage; even if that hook
is a script that runs `exit 0`.

### User Hooks
Users can also specify hooks in the [users](users/), under a subdirectory with
their name. Unlike platforms, the user name given to the main script need not
have a subdirectory for user hooks; likewise, the user need not have a hook
defined for every stage. If no hook exists for a given user at a given stage,
none is run; there are no defaults.

While there are no defaults, the directory [-templates](users/-templates)
defines some hooks that can be cloned and specialized. Since `-templates`
[should not](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_431)
be used as a user name on POSIX-compliant systems, it should be safe to use
here.



[^sane]: Canonically: check that the build environment is sane.
