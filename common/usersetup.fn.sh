#! /bin/bash
# Set up sudoers, etc. and set up the TGT_USER; lock the user account.

usersetup() {
  TGT_USER="$1"

  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

  useradd \
    --create-home \
    --user-group \
    --groups wheel \
    $TGT_USER
  sed -i "s/${TGT_USER}:!/${TGT_USER}:/" /etc/shadow
  passwd -e ${TGT_USER}
  passwd -l root

}
