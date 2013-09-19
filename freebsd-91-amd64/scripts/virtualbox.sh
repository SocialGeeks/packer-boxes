#!/bin/sh

# A lot of this script was lifted directly from:
# https://github.com/jedi4ever/veewee/tree/master/templates/freebsd-9.1-RELEASE-amd64
# with only a few minor changes.

sudo -s sh<<EOF

# Install and set up VirtualBox Guest Additions and dependencies
pkg_add -r yasm
pkg_add -r as86
pkg_add -r xsltproc
pkg_add -r kmk
pkg_add -r gtar
pkg_add -r cdrecord

cd /usr/ports/emulators/virtualbox-ose-additions
make install -DBATCH
echo 'vboxdrv_load="YES"' >> /boot/loader.conf
echo 'vboxnet_enable="YES"' >> /etc/rc.conf
echo 'vboxguest_enable="YES"' >> /etc/rc.conf
echo 'vboxservice_enable="YES"' >> /etc/rc.conf

rm /home/vagrant/VBoxGuestAdditions.iso

EOF

