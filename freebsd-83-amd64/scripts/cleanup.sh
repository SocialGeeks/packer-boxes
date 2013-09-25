#!/bin/sh

sudo -s sh<<EOF

# Undo the customizations
sed -i '' -e '/^REFUSE /d' /etc/portsnap.conf
sed -i '' -e '/^WITHOUT_X11/d' /etc/make.conf

# Cleaning portstree to save space
# http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/ports-using.html
pkg_add -r portupgrade
/usr/local/sbin/portsclean -C

EOF

