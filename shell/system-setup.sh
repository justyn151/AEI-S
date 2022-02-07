#!/bin/bash

echo "###########################################################"
echo "# PLEASE SELECT THE DRIVE WHERE GRUB WANT TO BE INSTALLED #"
echo "###########################################################"

# drives
fdisk -l
drives=''
read -p "Enter drives: " drives

echo "#############"
echo "# TIME ZONE #"
echo "#############"

# set timezone
region=''
city=''
echo "Setting timezone"
read -p "Please enter your region (use capital letters for first word): " region
read -p "Please enter your city (use capital lettter for fist word): " city

ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime

# hwclock
hwclock --systohc

echo "################"
echo "# LOCALE SETUP #"
echo "################"

# localization
echo "No support for now please do it manually"
echo "Uncomment en_US.UTF-8 UTF-8"

echo "################################"
echo "# INSTALL YOUR FAVORITE EDITOR #"
echo "################################"

# installing the editors
editors=''
read -p "Please install your editor [vim, nano]: " editors
pacman -Sy
pacman -S $editors

# edit the file
$editors /etc/locale.gen

# create locale.conf file
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "#########################"
echo "# USERNAME AND HOSTNAME #"
echo "#########################"

# set hostname
hostname=''
read -p "Hostname: " hostname
echo "$hostname" >> /etc/hostname

# set root passwd
passwd

# create new user
user=''
read -p "Enter a username: " user
useradd $user

# set the new user password
passwd $user

echo "########################"
echo "# ADDING USER TO GROUP #"
echo "########################"

# add user to group
usermod -aG wheel,audio,video,optical,storage $user

echo "###################"
echo "# INSTALLING SUDO #"
echo "###################"

# editting the /etc/sudoers (instruction)
echo "+ Uncomment the line that have %wheel%"

# installing sudo
pacman -S sudo

# openning the file
EDITOR=vim visudo

echo "###################"
echo "# INSTALLING GRUB #"
echo "###################"

# installing grub
pacman -S grub

echo "########################"
echo "# RUNNING GRUB-INSTALL #"
echo "########################"

# running grub-install
grub-install $drives

echo "#########################"
echo "# RUNNING GRUB-MKCONFIG #"
echo "#########################"

# creating grub config
grub-mkconfig -o /boot/grub/grub.cfg

echo "####################################"
echo "# INSTALL AND ENABLE NEWORKMANAGER #"
echo "####################################"

# installing network manager
pacman -S networkmanager

# enabling the network manager
systemctl enable NetworkManager

echo "####################################"
echo "# EXIT OUT FROM CHROOT ENVIRONMENT #"
echo "####################################"

# exit out from arch-chroot
exit
