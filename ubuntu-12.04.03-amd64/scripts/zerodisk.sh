#!/bin/sh

sudo -s sh<<EOF

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

EOF

