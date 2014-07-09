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
cd /usr/src
cat >> src.sup <<EOT
*default host=cvsup5.FreeBSD.org 
*default base=/var/db 
*default prefix=/usr 
*default release=cvs tag=RELENG_8_3
*default compress delete use-rel-suffix 
src-all
EOT
csup src.sup && rm src.sup
make build32 install32
ldconfig -v -m -R /usr/lib32

# disable X11 because vagrants are (usually) headless
cat >> /etc/make.conf << EOT
WITHOUT_X11="YES"
EOT

EOF

