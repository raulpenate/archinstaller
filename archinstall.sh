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

#Use the pacstrap script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmware vim nano 

#Generating an fstab file (use -U or -L to define by UUID or labels, respectively), in this case using -U
genfstab -U /mnt >> /mnt/etc/fstab

#Changing to chroot
arch-chroot /mnt

#Use timedatectl(1) to ensure the system clock is accurate:
echo -e "Using timedatectl to ensure the system clock is accurate"
timedatectl set-ntp true
echo -e "\nUsing timectl status"
timedatectl status

#Set the time zone:
echo -e "\nSet the time zone, search at /usr/share/zoneinfo"
ln -sf /usr/share/zoneinfo/America/El_Salvador /etc/localtime

#Run hwclock2 to generate /etc/adjtime:
echo -e "\nRunning hwclock to generate /etc/adjtime"
locale-gen

#Create the locale.conf file, and set the LANG variable accordingly:
echo -e "-----------------------------------"
echo -e "Creating the locale file, and setting the LANG variable"
echo -e "-----------------------------------"
echo -e "in this case LANG=en_US.UTF-8"
echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf

#Create the hostname file:
printf "\033c"
echo -e "==========================================
Insert your HOSTNAME (or how you wanna name your computer)
=========================================="
read HOSTNAME
echo -e $HOSTNAME >> /etc/hostname

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

#Updating repositories
pacman -Syy
##Basic things for arch
#Tools
pacman -S --noconfirm mtools dosftools base-devel linux-headers openssh
#Bootloader (GRUB)
pacman -Sy --noconfirm grub efibootmgr os-prober 
#Bluetooth
pacman -S --noconfirm bluez bluez-utils blueman pulseaudio-bluetooth
#Internet and Wifi
pacman -S --noconfirm NetworkManager network-manager-applet wireless-tools wpa_supplicant
#fonts
# agregarpolybar fonts https://github.com/adi1090x/polybar-themes
#Utilities
pacman -s --noconfirm tilix google-chrome firefox simplescreenrecorder obs-studio vlc papirus-icon-theme 

#Installing GNOME 
pacman -S --noconfirm xorg 

#Installing BSPWM
pacman -S --noconfirm xorg bspwm sxhkd picom nitrogen feh pcmanfm ranger polybar rofi

#Configuring bspwm
echo -e "exec bpswm &&\nsxhkdrc" >> .xinitrc
mkdir ~/.config/bspwm

#Installing I3WM

#Enable systemd process
systemctl enable NetworkManager 

#INSTALLING GRUB
#BIOS systems
grub-install --recheck /dev/sda

#UEFI systems
grub-mkconfig -o /boot/grub/grub.cfg

#Installing the directory in GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

#Create your root password
printf "\033c"
echo -e "==========================================
Insert your PASSWORD for ROOT (AKA SUDO PASSWORD)
=========================================="
passwd

#Create your user
printf "\033c"
echo -e "==========================================
Insert your USERNAME (yes your username, will be in wheel group)
=========================================="
read $CREATEUSERNAME
useradd -mG wheel $CREATEUSERNAME
echo -e "\n==========================================
Insert the PASSWORD Of $CREATEUSERNAME
=========================================="
passwd $CREATEUSERNAME

#Verifying if is EFI or not to install GRUB
echo -e "Verifing if is EFI or not..."
if [-d /sys/firmware/efi]
then
echo -e "Installing GRUB in UEFI\n" 
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
else
echo -e "Installing GRUB in BIOS\n"
grub-install --recheck /dev/sda
fi 
grub-mkconfig -o /boot/grub/grub.cfg

#END OF THE FIRST IF 
#WHERE YOU AGREE
fi