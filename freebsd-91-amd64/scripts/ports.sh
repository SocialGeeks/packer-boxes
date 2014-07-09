#!/bin/sh

# A lot of this script was lifted directly from:
# https://github.com/jedi4ever/veewee/tree/master/templates/freebsd-9.1-RELEASE-amd64
# with only a few minor changes.

sudo -s sh<<EOF

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

EOF

