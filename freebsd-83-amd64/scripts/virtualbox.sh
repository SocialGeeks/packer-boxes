#!/bin/sh

sudo -s sh <<EOF

# Install dependencies from packages to speed up install.
pkg_add -r yasm
pkg_add -r dev86

# Install and set up VirtualBox Guest Additions
cd /usr/ports/emulators/virtualbox-ose-additions
make install -DBATCH
echo 'vboxdrv_load="YES"' >> /boot/loader.conf
echo 'vboxnet_enable="YES"' >> /etc/rc.conf
echo 'vboxguest_enable="YES"' >> /etc/rc.conf
echo 'vboxservice_enable="YES"' >> /etc/rc.conf

rm /home/vagrant/VBoxGuestAdditions.iso

EOF

