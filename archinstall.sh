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
"
read -p "   --> This is a personal script, use it by your own risk, press ENTER to continue... <--"

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 1 --------------------------------```````````````
#```````````````----------------------- Installing Arch and basics -------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

# Use timedatectl to ensure the system clock is accurate:
timedatectl set-ntp true

# Use the pacstrap script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmwaqre vim nano

# Generating an fstab file (use -U or -L to define by UUID or labels, respectively), in this case using -U
genfstab -U /mnt >> /mnt/etc/fstab

# Changing to chroot
arch-chroot /mnt

# Use timedatectl(1) to ensure the system clock is accurate:
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
echo -e "-------------------------------------------------------"
echo -e "in this case LANG=en_US.UTF-8"
echo -e "LANG=en_US.UTF-8" >>/etc/locale.conf

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 2 --------------------------------```````````````
#```````````````------------------- Adding HOST, USERS and software ------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

# If u insert ur user ends
$CONFIRMATIONTRUE = true
while ["$CONFIRMATIONTRUE" = true]; do
    $HOSTNAME = ""
    printf "\033c"
    echo -e "----------------------------------------------------------"
    echo -e "Insert your HOSTNAME (or how you wanna name your computer)"
    echo -e "----------------------------------------------------------"
    read $HOSTNAME
    
    echo -e "-------------------"
    echo -e "Are you sure? (y/n)"
    echo -e "-------------------"
    read $CONFIRMATION
    
    if [ "$CONFIRMATION" = "y" ]; then
        $CONFIRMATIONTRUE = false
        # Create the hostname file:
        printf "\033c"
        echo -e $HOSTNAME >>/etc/hostname
    fi
    
done

# Add matching entries to hosts(5):
echo -e "\n--------------------------------"
echo -e "Adding matching entries to hosts"
echo -e "--------------------------------"
echo -e "127.0.0.1	localhost" >> /etc/hosts
echo -e "::1		localhost" >> /etc/hosts
echo -e "127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME" >> /etc/hosts

# Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.
# For LVM, system encryption or RAID, modify mkinitcpio.conf(5) and recreate the initramfs image:
mkinitcpio -P
# Updating repositories
pacman -Syy
## Basic things for arch
pacman -S --noconfirm mtools dosftools base-devel linux-headers openssh \
    noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
    grub efibootmgr os-prober \
    bluez bluez-utils blueman pulseaudio-bluetooth \
    NetworkManager network-manager-applet wireless-tools wpa_supplicant \
    tilix google-chrome firefox simplescreenrecorder obs-studio vlc papirus-icon-theme git \
    xorg i3-gaps dmenu nitrogen termite curl man-db \
    picom nitrogen feh pcmanfm ranger polybar rofi zsh\
    athura zathura-pdf-mupdf ffmpeg imagemagick  \
    zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
    arandr thunar htop bashtop

    systemctl enable NetworkManager
# Create your root password
$CONFIRMATIONTRUE = true
while ["$CONFIRMATIONTRUE" = true]; do
    printf "\033c"
    echo -e "-------------------------------------------------"
    echo -e "Insert your PASSWORD for ROOT (AKA SUDO PASSWORD)"
    echo -e "-------------------------------------------------"
    passwd
    
    echo -e "--------------------"
    echo -e "Are you sure? (y/n)"
    echo -e "--------------------"
    read $CONFIRMATION
    
    if [ "$CONFIRMATION" = "y" ]; then
        $CONFIRMATIONTRUE = false
    fi
    
done
# Create your user
$CONFIRMATIONTRUE = true
while ["$CONFIRMATIONTRUE" = true]; do
    printf "\033c"
    echo -e "---------------------------------------------------------------"
    echo -e "Insert your USERNAME (yes your username, will be in wheel group)"
    echo -e "----------------------------------------------------------------"
    read $CREATEUSERNAME
    
    echo -e "-------------------"
    echo -e "Are you sure? (y/n)"
    echo -e "-------------------"
    read $CONFIRMATION
    
    if [ "$CONFIRMATION" = "y" ]; then
        $CONFIRMATIONTRUE = false
        
        useradd -mG wheel $CREATEUSERNAME
        echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
    fi
    
done
# Create a password for your user
$CONFIRMATIONTRUE = true
while ["$CONFIRMATIONTRUE" = true]; do
    printf "\033c"
    echo -e "--------------------------------------"
    echo -e "Insert the PASSWORD Of $CREATEUSERNAME"
    echo -e "--------------------------------------"
    
    echo -e "-------------------"
    echo -e "Are you sure? (y/n)"
    echo -e "-------------------"
    read
    
    if [ "$CONFIRMATION" = "y" ]; then
        $CONFIRMATIONTRUE = false
        passwd $CREATEUSERNAME
    fi
    
done

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 3 --------------------------------```````````````
#```````````````------------------------- Installing GRUB ----------------------------``````````````` 
#```````````````----------------------------------------------------------------------```````````````

# Verifying if is EFI or not to install GRUB
echo -e "Verifing if is EFI or not..."
if [-d /sys/firmware/efi]; then
    echo -e "Installing GRUB in UEFI\n"
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
else
    echo -e "Installing GRUB in BIOS\n"
    grub-install --recheck /dev/sda
fi
# Verifying if OSPROBER is allowed
if [ -z $(grep -i "GRUB\_DISABLE\_OS\_PROBER=FALSE" /etc/default/grub)]; then
    echo -e "GRUB_DISABLE_OS_PROBER=FALSE" >> /etc/default/grub
fi
# Installing grub
grub-mkconfig -o /boot/grub/grub.cfg
