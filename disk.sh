# list all available drive using fdisk -l
fdisk -l

# select the disk to be installed on
drives=''
read -p "Disk name: " drives
echo "Installing on disk $drives"

# creating the partition
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $drives
  o # clear the disk
  n # create partition for boot
  p # primary partition
  1 # select partition number 1
    # select default
  +1M # size for the boot partition
  t # change partition type
  ef # change to EFI code ef
  n # create partition for filesystem
  p # primary partition
  2 # select partition number 2
    # default - start of partition
    # default - end of partition
  w # write changes to the disk
  q # quit fdisk
EOF

# set filesystem to ext4
files=''
fdisk -l
read -p "Select the biggest partition: " files
mkfs.ext4 $files

# mounting the filesystem
mount $files /mnt

# installing the system
pacstrap /mnt base linux linux-firmware

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt

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
adduser $user

# set the new user password
passwd $user

# installing grub
pacman -S grub

# running grub-install
grub-install $drives

# creating grub config
grub-mkconfig -o >> /boot/grub/grub.cfg

# installing network manager
pacman -S networkmanager

# enabling the network manager
systemctl enable networkmanager

# exit out from arch-chroot
exit

# unmount the partition
umount /mnt

# reboot the system
reboot
  
