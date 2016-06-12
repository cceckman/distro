#!/bin/sh
# Set up a headless VNC server, accessible only on localhost (/ via SSH tunnel.)

headlessvnc() {
  # Per https://wiki.archlinux.org/index.php/TigerVNC
  pacman --noconfirm -S tigervnc

  cat <<EOF >/etc/systemd/system/xvnc.socket
[Unit]
Description=XVNC Server

[Socket]
ListenStream=5900
Accept=yes

[Install]
WantedBy=sockets.target
EOF
  cat <<EOF >/etc/systemd/system/xvnc@.service
[Unit]
Description=XVNC Per-Connection Daemon

[Service]
ExecStart=-/usr/bin/Xvnc -localhost -inetd -query localhost -geometry 1920x1080 -once -SecurityTypes=None
User=nobody
StandardInput=socket
StandardError=syslog
EOF

  systemctl --now enable xvnc.socket
}
