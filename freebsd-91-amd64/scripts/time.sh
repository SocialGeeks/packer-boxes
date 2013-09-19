#!/bin/sh

# A lot of this script was lifted directly from:
# https://github.com/jedi4ever/veewee/tree/master/templates/freebsd-9.1-RELEASE-amd64
# with only a few minor changes.

sudo -s sh<<EOF

# Setup timezone
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/Boise /etc/localtime

#Set the time correctly
ntpdate -v -b in.pool.ntp.org

date > /etc/vagrant_box_build_time

EOF

