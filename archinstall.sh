#!/bin/bash
# SCRIPT MADE BY raulpenate
printf "\033c"
echo "
SCRIPT MADE BY:

 ██▀███   ▄▄▄       █    ██  ██▓     ██▓███  ▓█████  ███▄    █  ▄▄▄      ▄▄▄█████▓▓█████ 
▓██ ▒ ██▒▒████▄     ██  ▓██▒▓██▒    ▓██░  ██▒▓█   ▀  ██ ▀█   █ ▒████▄    ▓  ██▒ ▓▒▓█   ▀ 
▓██ ░▄█ ▒▒██  ▀█▄  ▓██  ▒██░▒██░    ▓██░ ██▓▒▒███   ▓██  ▀█ ██▒▒██  ▀█▄  ▒ ▓██░ ▒░▒███   
▒██▀▀█▄  ░██▄▄▄▄██ ▓▓█  ░██░▒██░    ▒██▄█▓▒ ▒▒▓█  ▄ ▓██▒  ▐▌██▒░██▄▄▄▄██ ░ ▓██▓ ░ ▒▓█  ▄ 
░██▓ ▒██▒ ▓█   ▓██▒▒▒█████▓ ░██████▒▒██▒ ░  ░░▒████▒▒██░   ▓██░ ▓█   ▓██▒  ▒██▒ ░ ░▒████▒
░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░▒▓▒ ▒ ▒ ░ ▒░▓  ░▒▓▒░ ░  ░░░ ▒░ ░░ ▒░   ▒ ▒  ▒▒   ▓▒█░  ▒ ░░   ░░ ▒░ ░
  ░▒ ░ ▒░  ▒   ▒▒ ░░░▒░ ░ ░ ░ ░ ▒  ░░▒ ░      ░ ░  ░░ ░░   ░ ▒░  ▒   ▒▒ ░    ░     ░ ░  ░
  ░░   ░   ░   ▒    ░░░ ░ ░   ░ ░   ░░          ░      ░   ░ ░   ░   ▒     ░         ░   
   ░           ░  ░   ░         ░  ░            ░  ░         ░       ░  ░            ░  ░        

Do me a favor and listen the wrecks and the regrettes.                                                                    

"
read -p "   --> This is a personal script, use it by your own risk, press ENTER to continue... <--"

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 1 --------------------------------```````````````
#```````````````----------------------- Installing Arch and basics -------------------```````````````
#```````````````----------------------------------------------------------------------```````````````


# Use timedatectl to ensure the system clock is accurate:
timedatectl set-ntp true

# Partitioning the disks
cfdisk 
# arch partition
printf "\033c"
lsblk
echo -e "\n---------------------------------------------------------------------------------"
read -p "Enter the /drive/partition where arch will be used (Ex: /sda/sda3): " ospartition
# Formating and mounting the partition
mkfs.ext4 $ospartition
mount $ospartition /mnt
# EFI or bios partition
printf "\033c"
CONFIRMATION=y
read -p "Did you create an EPI or BIOS partition? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" = "y" ]; then
    lsblk
    echo -e "\n---------------------------------------------------------------------------------"
    read -p "Enter the /drive/partition where the BOOTLOADER will be used (Ex: /sda/sda1): " bootpartition
    # Formating and mounting the partition
    mkfs.fat -F32 $bootpartition
    mkdir /mnt/boot
    mount $bootpartition /mnt/boot
fi
# EFI or bios partition
printf "\033c"
read -p "Did you create a SWAP partition? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" = "y" ]; then
    lsblk
    echo -e "\n---------------------------------------------------------------------------------"
    read -p "Enter the /drive/partition where the SWAP will be used (Ex: /sda/sda2): " swappartition
    # Formating and mounting the partition
    mkswap $swappartition
    swapon $swappartition
    mount $bootpartition /mnt/boot
fi


# Use the pacstrap script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmware vim

# Generating an fstab file (use -U or -L to define by UUID or labels, respectively), in this case using -U
genfstab -U /mnt >> /mnt/etc/fstab

# With sed, cutting this script until #chrootpart to execute it later from /mnt in chroot mode
sed '1,/^#chrootpart$/d' /root/arch-installer/archinstall.sh > /mnt/archinstallpart2.sh
chmod +x /mnt/archinstallpart2.sh

# Changing to chroot
arch-chroot /mnt ./archinstallpart2.sh
exit

#chrootpart
# Use timedatectl to ensure the system clock is accurate:
echo -e "Using timedatectl to ensure the system clock is accurate"
timedatectl set-ntp true
echo -e "\nUsing timectl status"
timedatectl status

# Set the time zone:
echo -e "\nSet the time zone, search at /usr/share/zoneinfo"
ln -sf /usr/share/zoneinfo/America/El_Salvador /etc/localtime

# Run hwclock2 to generate /etc/adjtime:
echo -e "\nRunning hwclock to generate /etc/adjtime"
locale-gen

# Create the locale.conf file, and set the LANG variable accordingly:
echo -e "-------------------------------------------------------"
echo -e "Creating the locale file, and setting the LANG variable"
echo -e "in this case LANG=en_US.UTF-8"
echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 2 --------------------------------```````````````
#```````````````------------------- Adding HOST, USERS and software ------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

# If u insert ur user ends
CONFIRMATION=y
while [ "$CONFIRMATION" = "y" ]
do
    HOSTNAME=""
    printf "\033c"
    echo -e "----------------------------------------------------------"
    echo -e "Insert your HOSTNAME (or how you wanna name your computer) :"
    read -p "New hostname: " HOSTNAME
    
    read -p "Are you sure? (y/n) : " CONFIRMATION  
    
    if [ "$CONFIRMATION" = "y" ]; then
        # Create the hostname file:
        echo -e $HOSTNAME > /etc/hostname
        break
    fi
    
done

# Add matching entries to hosts:
echo -e "\n--------------------------------"
echo -e "Adding matching entries to hosts"
echo -e "127.0.0.1	localhost" > /etc/hosts
echo -e "::1		localhost" >> /etc/hosts
echo -e "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts

# Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.
# For LVM, system encryption or RAID, modify mkinitcpio.conf and recreate the initramfs image:
mkinitcpio -P
# Updating repositories
pacman -Syy
## Basic things for arch
pacman -Sy --noconfirm mtools dosfstools base-devel linux-headers openssh
    noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome
    grub efibootmgr os-prober
    bluez bluez-utils blueman pulseaudio-bluetooth
    networkmanager network-manager-applet wireless_tools wpa_supplicant
    tilix google-chrome firefox simplescreenrecorder obs-studio vlc papirus-icon-theme git
    xorg i3-gaps dmenu nitrogen curl man-db
    picom nitrogen feh pcmanfm ranger rofi zsh most
    zathura zathura-pdf-mupdf ffmpeg imagemagick
    zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl
    arandr thunar htop bashtop

    systemctl enable NetworkManager

# Create your root password
while [ "$CONFIRMATION" = "y" ]
do
    echo -e "\n-------------------------------------------------"
    echo -e "Insert your PASSWORD for ROOT (AKA SUDO PASSWORD)"
    passwd
    
    read -p "Are you sure? (y/n) : " CONFIRMATION  
    
    if [ "$CONFIRMATION" = "y" ]; then
        break
    fi

done

# Create your user
while [ "$CONFIRMATION" = "y" ]
do
    echo -e "\n---------------------------------------------------------------"
    echo -e "Insert your USERNAME (yes your username, will be added in wheel group)"
    read -p "--> " CREATEDUSERNAME
    
    read -p "Are you sure? (y/n) : " CONFIRMATION  

    if [ "$CONFIRMATION" = "y" ]; then
        echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
        useradd -mG wheel $CREATEDUSERNAME
        break
    fi
    
done
# Create a password for your user
while [ "$CONFIRMATION" = "y" ]
do
    echo -e "\n--------------------------------------"
    echo -e "Insert the PASSWORD Of $CREATEDUSERNAME"

    passwd $CREATEDUSERNAME
    
    read -p "Are you sure? (y/n) : " CONFIRMATION  

    if [ "$CONFIRMATION" = "y" ]; then
        break 
    fi
    
done

# Verifying if is EFI or not to install GRUB
echo -e "\n--------------------------------------"
echo -e "Verifing if is EFI or not..."
if [ -d /sys/firmware/efi ]; then
    echo -e "Installing GRUB in UEFI\n"
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
else
    echo -e "Installing GRUB in BIOS\n"
    grub-install --recheck /dev/sda
fi

# Verifying if OSPROBER is allowed
if [ -z $(grep -i "GRUB\_DISABLE\_OS\_PROBER=FALSE" /etc/default/grub) ]; then
    echo -e "GRUB_DISABLE_OS_PROBER=FALSE" >> /etc/default/grub
fi
# Installing grub
grub-mkconfig -o /boot/grub/grub.cfg

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 3 --------------------------------```````````````
#```````````````----------------------------- DOTFILES -------------------------------``````````````` 
#```````````````----------------------------------------------------------------------```````````````

# to automatically delete this file
#rm 