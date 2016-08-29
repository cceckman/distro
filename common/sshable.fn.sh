#!/bin/bash
# Generate new host keys, and start the service.
# Run within the chroot.

sshable() {
  mods="$1"

  if [ "$mods" == y* ]; then
    # Generate new moduli
    awk '$5 > 2000' /etc/ssh/moduli > "/tmp/moduli"
    mv "/tmp/moduli" /etc/ssh/moduli

    ssh-keygen -G /etc/ssh/moduli.all -b 4096
    ssh-keygen -T /etc/ssh/moduli.safe -f /etc/ssh/moduli.all
    mv /etc/ssh/moduli.safe /etc/ssh/moduli
    rm /etc/ssh/moduli.all

  fi

  # Generate new host keys
  pushd /etc/ssh
    rm -f ssh_host*key*
    ssh-keygen -N '' -t ed25519 -f ssh_host_ed25519_key < /dev/null
    ssh-keygen -N '' -t rsa -b 4096 -f ssh_host_rsa_key < /dev/null
  popd

  sed -i 's/^PermitRootLogin .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PasswordAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^ChallengeResponseAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^PubkeyAuthentication .*$//g' /etc/ssh/sshd_config
  sed -i 's/^Protocol .*$//g' /etc/ssh/sshd_config
  cat - << HRD >>/etc/ssh/sshd_config
AllowGroups ssh-users
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com
HRD

  cat - << HRD >>/etc/ssh/ssh_config
# Github needs diffie-hellman-group-exchange-sha1 some of the time but not always.
Host github.com
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1
Host *
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
  KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
  Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160,umac-128@openssh.com
HRD

  groupadd ssh-users

  systemctl --now enable sshd.service

}

