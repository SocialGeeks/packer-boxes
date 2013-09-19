#!/bin/sh

apt-get install sudo
sed -i -e 's/\%sudo[\t]ALL=(ALL:ALL) ALL//\%sudo[\t]ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

update-rc.d ssh enable

