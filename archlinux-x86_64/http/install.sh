#!/bin/sh
DISK=$(cat .primary_disk)
IFACE=$(cat .primary_interface)

# Most of this script was lifted from https://github.com/jedi4ever/veewee/tree/master/templates/archlinux-x86_64
# and changed to work with packer with my own customizations

# Format partitions created in the boot_command
mkfs.ext4 ${DISK}1
mkfs.ext4 ${DISK}3

# Format and turn on swap partition
mkswap ${DISK}2
swapon ${DISK}2

# Mount other partitions
mount ${DISK}3 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

# Get reflector so that we can update the mirrorlist
pacstrap /mnt base reflector

genfstab -p /mnt > /mnt/etc/fstab

arch-chroot /mnt <<ENDCHROOT

# Set root password for vagrant
passwd<<EOF
vagrant
vagrant
EOF

# Setup timezone
ln -s /usr/share/zoneinfo/America/Boise /etc/localtime

# Setup language/locale settings
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
export LANG=en_US.UTF-8
sed -i -e 's/\\#en\\_US/en\\_US/g' /etc/locale.gen
locale-gen
echo 'KEYMAP=us' > /etc/vconsole.conf
echo 'vagrant-arch' > /etc/hostname

# PACMAN_REFLECTOR_ARGS can be used to pick a suitable mirror for pacman
if [ -z "$PACMAN_REFLECTOR_ARGS" ]; then
  export PACMAN_REFLECTOR_ARGS='--verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist'
fi

# Update the mirrorlist to 5 recently updated mirrors sorted by download rate
reflector $PACMAN_REFLECTOR_ARGS

# Upgrade Pacman DB
pacman-db-upgrade

# Force pacman to refresh the package lists
pacman -Syy

# Remove reflector as not required anymore
pacman -Rns --noconfirm reflector

# Setup sudo access for no password to wheel group
pacman --noconfirm -S sudo
sed -i -e 's/\# \%wheel ALL=(ALL) NOPASSWD/\%wheel ALL=(ALL) NOPASSWD/g' /etc/sudoers

# Setup SSH and networking
pacman --noconfirm -S openssh
sed -i -e 's/\#Pub/Pub/g' /etc/ssh/sshd_config
systemctl enable dhcpcd@${IFACE}.service
systemctl enable sshd.service

# Enable SSH root login
sed -i -e 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Setup syslinux boot loader
pacman --noconfirm -S gptfdisk syslinux
syslinux-install_update -iam

# Fix boot disk if needed
if [[ "${DISK}" != "/dev/sda" ]]; then 
    sed -i "s|/dev/sda|${DISK}|g" /boot/syslinux/syslinux.cfg
fi
ENDCHROOT

# Umount partitions and reboot into working system
umount ${DISK}1
umount ${DISK}3
swapoff ${DISK}2
reboot

