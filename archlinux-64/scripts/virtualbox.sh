#!/bin/sh

# Install and set up VirtualBox Guest Additions
pacman -S --noconfirm virtualbox-guest-utils
cat <<EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF

rm /root/VBoxGuestAdditions.iso

