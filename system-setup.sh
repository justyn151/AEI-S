# drives
fdisk -l
drives=''
read -p "Enter drives: " drives

# set timezone
region=''
city=''
echo "Setting timezone"
read -p "Please enter your region (use capital letters for first word): " region
read -p "Please enter your city (use capital lettter for fist word): " city

ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime

# hwclock
hwclock --systohc

# localization
echo "No support for now please do it manually"
echo "Uncomment en_US.UTF-8 UTF-8"

# installing the editors
editors=''
read -p "Please install your editor [vim, nano]: " editors
pacman -Sy
pacman -S $editors

# edit the file
$editors /etc/locale.gen

# create locale.conf file
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

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

# add user to group
usermod -aG wheel,audio,video,optical,storage $user

# editting the /etc/sudoers (instruction)
echo "+ Uncomment the line that have %wheel%"

# installing sudo
pacman -S sudo

# openning the file
EDITOR=vim visudo

# installing grub
pacman -S grub

# running grub-install
grub-install $drives

# creating grub config
grub-mkconfig -o /boot/grub/grub.cfg

# installing network manager
pacman -S networkmanager

# enabling the network manager
systemctl enable NetworkManager

# exit out from arch-chroot
exit
