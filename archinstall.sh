#!/bin/bash

#SCRIPT MADE BY raulpenate
echo -e "===================================================
BEFORE RUNNING THIS SCRIPT PLEASE\!\!\!\!\!\!\!\!\n
THIS IS A PERSONAL SCRIPT DON'T USE IT, IF YOU WANT 
TO USE IT ON YOUR OWN RISK, I WON'T BE RESPONSABLE
FOR DAMAGES\!\!\!\!\!\!\!\!
IF YOU CONTINUE IT MEANS YOU READ AND ACCEPT THAT.
===================================================
PERSONAL REMINDER:\n
FIRST CREATE A PARTITION YOUR DISK AND MOUNT YOUR 
DEVICE IN /mnt AND YOUR EFI at /mnt/boot/efi
THIS SCRIPT WILL ASK YOU LATER FOR HOW MUCH
SWAP YOU WANNA INSTALL, I'LL DETECT IF
YOU USE GRUB FOR EFI OR BIOS
===================================================
WRITE EXACTLY WITHOUT QUOTES
\"I agree\" TO CONTINUE
==================================================="

READ $AGREEING

if [$AGREEING === "I agree"]; then

#Verify if is EFI or not
echo -e "Verify if is EFI or not"
ls /sys/firmware/efi/efivars

#Use timedatectl(1) to ensure the system clock is accurate:
echo -e "Using timedatectl to ensure the system clock is accurate"
timedatectl set-ntp true
echo -e "\nUsing timectl status"
timedatectl status

#Set the time zone:
echo -e "\nSet the time zone, search at /usr/share/zoneinfo"
ln -sf /usr/share/zoneinfo/America/El_Salvador /etc/localtime

#Run hwclock(8) to generate /etc/adjtime:
echo -e "\nRunning hwclock to generate /etc/adjtime"
locale-gen

#Use the pacstrap(8) script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmware vim 

#Create the locale.conf(5) file, and set the LANG variable accordingly:
echo -e "-----------------------------------"
echo -e "Creating the locale file, and setting the LANG variable"
echo -e "-----------------------------------"
echo -e "in this case LANG=en_US.UTF-8"
echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf

#Create the hostname file:
printf "\033c"
echo -e "==========================================\n
Insert your HOSTNAME (or how you wanna name your computer)\n
=========================================="
read HOSTNAME
echo -e$HOSTNAME >> /etc/hostname

#Add matching entries to hosts(5):
echo -e "\n-----------------------------------"
echo -e "Adding matching entries to hosts"
echo -e "-----------------------------------"
echo -e "127.0.0.1	localhost" >> /etc/hosts
echo -e "::1		localhost" >> /etc/hosts
echo -e "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts

#Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.
#For LVM, system encryption or RAID, modify mkinitcpio.conf(5) and recreate the initramfs image:
mkinitcpio -P

#Downloading necessary packages
printf "\033c"
echo -e "-----------------------------------"
echo -e "Select wich DE or WM"
echo -e "-----------------------------------\n"
echo -e "1 - KDE plasma"
echo -e "2 - GNOME"
echo -e "3 - i3-WM"

read $OPTION

pacman -Syy
pacman -Sy --noconfirm grub efibootmgr 
pacman -S --noconfirm xorg sddm plasma kde-applications firefox simplescreenrecorder obs-studio vlc papirus-icon-theme kdenlive materia-kde

#Enable systemd process
systemctl enable NetworkManager

#INSTALLING GRUB
#BIOS systems
grub-install --recheck /dev/sda

#UEFI systems
grub-mkconfig -o /boot/grub/grub.cfg

#Installing the directory in GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

#END OF THE FIRST IF 
#WHERE YOU AGREE
fi