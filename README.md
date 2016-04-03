# Ambroix
A Linux build brought to you by [Arch](http://archlinux.org) and [cceckman](http://cceckman.com).

## About

### Well, technically...
...it's a set of scripts that set up a base Arch image, and initialize it with
my (cceckman's) development environment.

### How does it work?
See more about the ~~actual~~ planned architecture in [ambroix.md](ambroix.md).

### What are you trying to do here?
I'm trying to be able to reliably repropduce my development environment.
No hours remembering which packages are needed, listing repositories out,
customizing environment variables and RC files; just run the script, and start
coding.

Ambroix is particularly targetted towards VM environments, such as
[VirtualBox](https://virtualbox.org) and 
[Google Compute Engine](https://cloud.google.com), but with plans to support
the [Raspberry Pi](https://raspberrypi.org) as well.

### Can I use it?
You can try, but it won't work; I'm not about to hand out Github access tokens
for my account.

What you *can* do is branch it, customize it, and send pull requests for general
improvements. I'm going to be continually refactoring it to separate out
my custom stuff from the image itself, so it may soon be in a place where it's
useful to you.

### Why the name?
The [Pont Ambroix](https://en.wikipedia.org/wiki/Pont_Ambroix) was a Roman bridge;
one of the eleven arches remains standing (as of 2016).

Someone already took the name [Keystone](https://github.com/concordusapps/keystone)
for a build on top of Arch.


## Plans

[ ] Refactor:
  [ ] Write a plan for the below.
  [ ] Structure along a "hooks" pattern, to better separate platform-dependent and
      platform-independent code.
  [ ] Separate user-specific / user-preference code from common code; integrate
      with user setup and hooks. 
[ ] Support environments:
  [ ] Raspberry Pi
  [ ] Google Cloud, including initializing the VM
  [ ] Amazon VMs
[ ] Add:
  [ ] All the TODOs in the code today.
  [ ] U2F authentication via [PAM](https://developers.yubico.com/pam-u2f/)
