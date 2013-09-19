#!/bin/sh

apt-get install sudo
sed -i -e 's/\# \%wheel ALL=(ALL) NOPASSWD/\%wheel ALL=(ALL) NOPASSWD/g' /etc/sudoers
sed -i -e 's/\# Defaults     env_keep += "PKG/Defaults     env_keep += "PKG/' /etc/sudoers

update-rc.d ssh enable

