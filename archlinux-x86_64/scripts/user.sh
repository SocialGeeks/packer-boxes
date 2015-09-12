#!/bin/sh

# Most of this script was lifted from https://github.com/jedi4ever/veewee/tree/master/templates/archlinux-x86_64
# and changed to work with packer with my own customizations

passwd -l root

# Setup vagrant user
pacman --noconfirm -S bash wget vim
useradd -m -G wheel -r vagrant
chsh -s /bin/bash vagrant
cd /home/vagrant
mkdir -m 700 .ssh
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
mv vagrant.pub .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
chown -R vagrant:vagrant .ssh

