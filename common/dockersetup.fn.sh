# Set up docker, from a user's perspective.
# Call from a firstboot hook.

dockersetup() {
  pacman -S noconfirm docker
  systemctl enable --now docker.service
  gpasswd -a $TGT_USER docker
}
