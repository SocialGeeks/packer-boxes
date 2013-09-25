#!/bin/sh

sudo -s sh <<EOF

# Setup SSH for pub key access
sed -i -e 's/\#Pub/Pub/g' /usr/local/etc/ssh/sshd_config

EOF

