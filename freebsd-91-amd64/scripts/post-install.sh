#!/bin/sh

# A lot of this script was lifted directly from:
# https://github.com/jedi4ever/veewee/tree/master/templates/freebsd-9.1-RELEASE-amd64
# with only a few minor changes.

sudo -s sh<<EOF

# Setup timezone
ln -s /usr/share/zoneinfo/America/Boise /etc/localtime

#Set the time correctly
ntpdate -v -b in.pool.ntp.org

date > /etc/vagrant_box_build_time

# Install kernel sources for use with the virtualbox-ose-additions port
cat >> src.sup <<EOT
*default host=cvsup5.FreeBSD.org 
*default base=/var/db 
*default prefix=/usr 
*default release=cvs tag=. 
*default compress delete use-rel-suffix 
src-all
EOT
csup src.sup && rm src.sup
cd /usr/src
make build32 install32

# allow freebsd-update to run fetch without stdin attached to a terminal
sed 's/\[ ! -t 0 \]/false/' /usr/sbin/freebsd-update > /tmp/freebsd-update
chmod +x /tmp/freebsd-update

# update FreeBSD
PAGER=/bin/cat /tmp/freebsd-update fetch
PAGER=/bin/cat /tmp/freebsd-update install

# disable X11 because vagrants are (usually) headless
cat >> /etc/make.conf <<EOT
WITHOUT_X11="YES"
EOT

# allow portsnap to run fetch without stdin attached to a terminal
sed 's/\[ ! -t 0 \]/false/' /usr/sbin/portsnap > /tmp/portsnap
chmod +x /tmp/portsnap

# reduce the ports we extract to a minimum
cat >> /etc/portsnap.conf <<EOT
REFUSE accessibility arabic archivers astro audio benchmarks biology cad
REFUSE chinese comms databases deskutils distfiles dns editors finance french
REFUSE ftp games german graphics hebrew hungarian irc japanese java korean
REFUSE mail math multimedia net net-im net-mgmt net-p2p news packages palm
REFUSE polish portuguese print russian science sysutils ukrainian
REFUSE vietnamese www x11 x11-clocks x11-drivers x11-fm x11-fonts x11-servers
REFUSE x11-themes x11-toolkits x11-wm
EOT

# get new ports
/tmp/portsnap fetch extract

# Install and set up VirtualBox Guest Additions
cd /usr/ports/emulators/virtualbox-ose-additions
make install -DBATCH
echo 'vboxdrv_load="YES"' >> /boot/loader.conf
echo 'vboxnet_enable="YES"' >> /etc/rc.conf
echo 'vboxguest_enable="YES"' >> /etc/rc.conf
echo 'vboxservice_enable="YES"' >> /etc/rc.conf

# undo our customizations
sed -i '' -e '/^REFUSE /d' /etc/portsnap.conf
sed -i '' -e '/^WITHOUT_X11/d' /etc/make.conf

# Cleaning portstree to save space
# http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/ports-using.html
pkg_add -r portupgrade
/usr/local/sbin/portsclean -C

# As sharedfolders are not in defaults ports tree
# We will use vagrant via NFS
# Enable NFS
echo 'rpcbind_enable="YES"' >> /etc/rc.conf
echo 'nfs_server_enable="YES"' >> /etc/rc.conf
echo 'mountd_flags="-r"' >> /etc/rc.conf

# Setup SSH for pub key access
sed -i -e 's/\#Pub/Pub/g' /etc/ssh/sshd_config

# Setup vagrant user
pkg_add -r bash
chsh -s /usr/local/bin/bash vagrant
cd /home/vagrant
mkdir -m 700 .ssh
fetch https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
mv vagrant.pub .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
chown -R vagrant:vagrant .ssh

pw groupadd vboxusers
pw groupmod vboxusers -m vagrant

rm /home/vagrant/VBoxGuestAdditions.iso

EOF

