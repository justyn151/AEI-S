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
