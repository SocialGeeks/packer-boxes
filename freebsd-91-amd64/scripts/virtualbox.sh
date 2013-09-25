#!/bin/sh

# A lot of this script was lifted directly from:
# https://github.com/jedi4ever/veewee/tree/master/templates/freebsd-9.1-RELEASE-amd64
# with only a few minor changes.

sudo -s sh<<EOF

# Install dependencies, from packages, for virtualbox-ose-additions
pkg_add -r yasm
pkg_add -r dev86

# Install virtualbox-ose-additions from ports (to get latest version)
cd /usr/ports/emulators/virtualbox-ose-additions
make install -DBATCH
echo 'vboxdrv_load="YES"' >> /boot/loader.conf
echo 'vboxnet_enable="YES"' >> /etc/rc.conf
echo 'vboxguest_enable="YES"' >> /etc/rc.conf
echo 'vboxservice_enable="YES"' >> /etc/rc.conf

rm /home/vagrant/VBoxGuestAdditions.iso

EOF

