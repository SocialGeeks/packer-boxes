#!/bin/sh

# Most of this script was lifted from https://github.com/jedi4ever/veewee/tree/master/templates/archlinux-x86_64
# and changed to work with packer with my own customizations

echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Disable SSH root login
sed -i -e 's/\#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Install and set up VirtualBox Guest Additions
pacman -S --noconfirm virtualbox-guest-utils
cat <<EOF > /etc/modules-load.d/virtualbox.conf
vboxguest
vboxsf
vboxvideo
EOF
groupadd vboxsf

# Setup vagrant user
pacman --noconfirm -S bash wget vim
useradd -m -G wheel,vboxsf -r vagrant
passwd -d vagrant
passwd vagrant<<EOF
vagrant
vagrant
EOF
chsh -s /bin/bash vagrant
mkdir -m 700 /home/vagrant/.ssh
wget --no-check-certificate \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' \ 
  -o /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
sed -i -e 's/\\#Pub/Pub/g' /etc/ssh/sshd_config

rm /root/VBoxGuestAdditions.iso
