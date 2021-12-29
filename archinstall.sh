#!/bin/bash
# SCRIPT MADE BY raulpenate
printf "\033c"
# colors
NC='\033[0m' # No Color
# Bold High Intensity
BIYellow='\033[1;93m'     # Yellow
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
# Underline
UYellow='\033[4;33m'      # Yellow

# prentation and warning message
echo -e "
$BIWhite SCRIPT MADE BY$BIYellow RAULPENATE$BIWhite:
$BICyan
 ▄▄▄       ██▀███   ▄████▄   ██░ ██                                        
▒████▄    ▓██ ▒ ██▒▒██▀ ▀█  ▓██░ ██▒                                       
▒██  ▀█▄  ▓██ ░▄█ ▒▒▓█    ▄ ▒██▀▀██░                                       
░██▄▄▄▄██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒░▓█ ░██                                        
 ▓█   ▓██▒░██▓ ▒██▒▒ ▓███▀ ░░▓█▒░██▓                                       
 ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ░▒ ▒  ░ ▒ ░░▒░▒                                       
  ▒   ▒▒ ░  ░▒ ░ ▒░  ░  ▒    ▒ ░▒░ ░                                       
  ░   ▒     ░░   ░ ░         ░  ░░ ░                                       
      ░  ░   ░     ░ ░       ░  ░  ░                                       
                   ░                                                       
 ██▓ ███▄    █   ██████ ▄▄▄█████▓ ▄▄▄       ██▓     ██▓    ▓█████  ██▀███  
▓██▒ ██ ▀█   █ ▒██    ▒ ▓  ██▒ ▓▒▒████▄    ▓██▒    ▓██▒    ▓█   ▀ ▓██ ▒ ██▒
▒██▒▓██  ▀█ ██▒░ ▓██▄   ▒ ▓██░ ▒░▒██  ▀█▄  ▒██░    ▒██░    ▒███   ▓██ ░▄█ ▒
░██░▓██▒  ▐▌██▒  ▒   ██▒░ ▓██▓ ░ ░██▄▄▄▄██ ▒██░    ▒██░    ▒▓█  ▄ ▒██▀▀█▄  
░██░▒██░   ▓██░▒██████▒▒  ▒██▒ ░  ▓█   ▓██▒░██████▒░██████▒░▒████▒░██▓ ▒██▒
░▓  ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░  ▒ ░░    ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░░░ ▒░ ░░ ▒▓ ░▒▓░
 ▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░    ░      ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░ ░ ░  ░  ░▒ ░ ▒░
 ▒ ░   ░   ░ ░ ░  ░  ░    ░        ░   ▒     ░ ░     ░ ░      ░     ░░   ░ 
 ░           ░       ░                 ░  ░    ░  ░    ░  ░   ░  ░   ░     
                                                                                
$BIWhite
Do me a favor and listen the wrecks and the regrettes.                                                                    
"

if [ -d /sys/firmware/efi ]; then
    echo -e "\nYour device is$BIYellow EFI$BIWhite, if you create a bootloader use $BIYellow\"EFI System\"$BIWhite and use a $BIYellow\"GPT\"$BIWhite partition$UYellow\n"
else
    echo -e "\nYour device is$BIYellow BIOS$BIWhite, if you create a bootloader use $BIYellow\"BIOS boot\"$BIWhite and use a $BIYellow\"DOS or MBR\"$BIWhite partition$UYellow\n"
fi

read -p "--> This is a personal script, use it by your own risk, press ENTER to continue... <--"

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 1 --------------------------------```````````````
#```````````````----------------------- Installing Arch and basics -------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

#Adding more paralleldownloads
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 6/" /etc/pacman.conf
# Use timedatectl to ensure the system clock is accurate:
timedatectl set-ntp true
#Disk formating and mounting
read -p "Do you want to format and partition your disk? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" = "y" ]; then
    #umounting if the script was runned already
    umount -R /mnt
    umount -R /mnt/boot
    rm -rf /mnt/boot
    rm -rf /mnt/efi 
    # Partitioning the disks
    cfdisk 
    # arch partition
    printf "\033c"
    lsblk
    echo -e "$NC\n---------------------------------------------------------------------------------"
    read -p "Enter the /dev/drive where ARCH will be used (Ex: sda3): " ospartition
    # Formating and mounting the partition
    mkfs.ext4 /dev/$ospartition
    mount /dev/$ospartition /mnt
    # EFI or bios partition
    echo -e "\n---------------------------------------------------------------------------------"
    read -p "Did you create an \"EPI or BIOS partition\"? (y/n): " CONFIRMATION
    echo -e "\n---------------------------------------------------------------------------------"
    if [ "$CONFIRMATION" = "y" ]; then
        lsblk
        echo -e "\n---------------------------------------------------------------------------------"
        read -p "Enter the /dev/drive where the BOOTLOADER will be used (Ex: sda1): " bootpartition
        echo -e "\n---------------------------------------------------------------------------------"
        # Formating and mounting the partition
        mkfs.fat -F32 /dev/$bootpartition
        mkdir /mnt/boot
        mount /dev/$bootpartition /mnt/boot
    fi
    # EFI or bios partition
    read -p "Did you create a SWAP partition? (y/n): " CONFIRMATION
    echo -e "\n---------------------------------------------------------------------------------"
    if [ "$CONFIRMATION" = "y" ]; then
        lsblk
        echo -e "\n---------------------------------------------------------------------------------"
        read -p "Enter the /dev/drive where the SWAP will be used (Ex: sda2): " swappartition
        # Formating and mounting the partition
        mkswap /dev/$swappartition
        swapon /dev/$swappartition
    fi
fi

# Use the pacstrap script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmware vim sed

# Generating an fstab file (use -U or -L to define by UUID or labels, respectively), in this case using -U
genfstab -U /mnt >> /mnt/etc/fstab

# With sed, cutting this script until #chrootpart to execute it later from /mnt in chroot mode
sed '1,/^#chrootpart$/d' /root/arch-installer/archinstall.sh > /mnt/archinstallpart2.sh
chmod +x /mnt/archinstallpart2.sh

# Changing to chroot
arch-chroot /mnt ./archinstallpart2.sh
exit

#chrootpart
#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 2 --------------------------------```````````````
#```````````````------------------- Adding HOST, USERS and software ------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

# colors
NC='\033[0m' # No Color
# Bold High Intensity
BIYellow='\033[1;93m'     # Yellow
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
# Underline
UYellow='\033[4;33m'      # Yellow

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 6/" /etc/pacman.conf
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
hwclock --systohc

# Create the locale.conf file, and set the LANG variable accordingly:
echo -e "-------------------------------------------------------"
echo -e "Creating the locale file, and setting the LANG variable"
echo -e "in this case LANG=en_US.UTF-8"
echo -e "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo -e "LANG=en_US.UTF-8" >> /etc/locale.conf

# setting COLEMAK as a main layout
KEYMAP=colemak
# creating hostname
printf "\033c"
echo -e "----------------------------------------------------------"
echo -e "Insert your HOSTNAME (or how you wanna name your computer) :"
read -p "New hostname: " HOSTNAME
# Create the hostname file:
echo -e $HOSTNAME > /etc/hostname

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
pacman -Sy --noconfirm mtools dosfstools base-devel linux-headers openssh curl man-db
## Windows system display
pacman -Sy --noconfirm xorg xorg-server xorg-xinit xorg-xbacklight
## Window manager
pacman -Sy --noconfirm i3-gaps dmenu nitrogen betterlockscreen
## Login + Greeter
pacman -Sy --noconfirm lightdm lightdm-webkit2-greeter lightdm-webkit-theme-aether lightdm-gtk-greeter-settings
## Fonts
pacman -Sy --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome
## Grub stuff
pacman -Sy --noconfirm grub efibootmgr os-prober
## bluetooth
pacman -Sy --noconfirm bluez bluez-utils blueman pulseaudio-bluetooth
## Wifi
pacman -Sy --noconfirm networkmanager network-manager-applet wireless_tools wpa_supplicant
## Software of my preference
pacman -Sy --noconfirm tilix firefox simplescreenrecorder obs-studio vlc papirus-icon-theme git
pacman -Sy --noconfirm picom nitrogen feh pcmanfm ranger rofi zsh most
pacman -Sy --noconfirm zathura zathura-pdf-mupdf ffmpeg imagemagick
pacman -Sy --noconfirm zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl
pacman -Sy --noconfirm arandr thunar htop bashtop

# Enabling software
systemctl enable NetworkManager
systemctl enable lightdm
echo "greeter-session=lightdm-webkit2-greeter" >> /etc/lightdm/lightdm.conf

# Create your root password
echo -e "\n-------------------------------------------------"
echo -e "Insert your PASSWORD forROOT (AKA SUDO PASSWORD)"
passwd
# Create your user
echo -e "\n---------------------------------------------------------------"
echo -e "Insert your USERNAME (yes your username, will be added in wheel group)"
read -p "--> " CREATEDUSERNAME
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
useradd -mG wheel $CREATEDUSERNAME
# Create a password for your user
echo -e "\n--------------------------------------"
echo -e "Insert the PASSWORD of $CREATEDUSERNAME"
passwd $CREATEDUSERNAME
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
if [ -z $(grep -i "\nGRUB\_DISABLE\_OS\_PROBER=false" /etc/default/grub) ]; then
    echo -e "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
fi
# Installing grub
grub-mkconfig -o /boot/grub/grub.cfg

# With sed, cutting this script until userpartchrootpart to execute it later from /mnt in chroot mode
USERPATH=/home/$CREATEDUSERNAME/archinstallpart3.sh
sed '1,/^#userpart$/d' archinstallpart2 > USERPATH
chown $CREATEDUSERNAME:$CREATEDUSERNAME USERPATH
chmod +x $USERPATH
su -c $USERPATH -s /bin/sh $CREATEDUSERNAME

# Instructions
echo -e "\n----------------------------------------------------------------"
echo -e "Don't forget to \"umount -R /mnt\" after restarting your Computer"
echo -e "------------------------------------------------------------------\n"
exit 

#userpart
#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 3 --------------------------------```````````````
#```````````````----------------------------- DOTFILES -------------------------------``````````````` 
#```````````````----------------------------------------------------------------------```````````````

# installing yay
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si
# installing Qogir cursor
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER cd Qogir-icon-theme/
./Qogir-icon-theme/install.sh

# installing package with yay
yay -Syy
yay -S --nocofirm polybar papirus-nord dunst kity
yay -S --nocofirm nerd-fonts-roboto-mono
cd ~/.config/polybar git clone --depth=1 https://github.com/adi1090x/polybar-themes.git 
cd polybar-themes 
chmod +x setup.sh


# to automatically delete this file
