#!/bin/bash
###################################################################
#                   SCRIPT MADE BY raulpenate                     #
#                                                                 #
#    if you want to connect using your WIFI in arch use:          #
#    iwctl --passphrase passphrase station device connect SSID    #
#                                                                 #
#    check iwctl arch wiki to check more things about using wifi  #
###################################################################
printf "\033c"
# colors
NC='\033[0m' # No Color
# Bold High Intensity
BIYellow='\033[1;93m'     # Yellow
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
# Underline
UYellow='\033[4;33m'      # Yellow

# Presentation and warning message
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
    Do me a favor and listen The Wrecks and KennyHoppla.                                                                    
"

if [ -d /sys/firmware/efi ]; then
    echo -e "\nYour device is$BIYellow EFI$BIWhite, if you create a bootloader use $BIYellow\"EFI System\"$BIWhite and use a $BIYellow\"GPT\"$BIWhite partition$UYellow\n"
else
    echo -e "\nYour device is$BIYellow BIOS$BIWhite, if you create a bootloader use $BIYellow\"BIOS boot\"$BIWhite and use a $BIYellow\"DOS or MBR\"$BIWhite partition$UYellow\n$NC"
fi

read -p "--> This is a personal script, use it by your own risk, press ENTER to continue... <--"

#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 1 --------------------------------```````````````
#```````````````----------------------- Installing Arch and basics -------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

# Pick a keyboard layout
while true; do
    #Array of options
    declare -a ArrLayout=("qwerty" "colemak" "dvorak")
    #Looping the array 
    for item in "${ArrLayout[@]}"
    do
        ((CounterArray++));
        echo -e " $CounterArray) $item"
    done
    #Reading the selected option
    read -p "Select the keyboard layout --> " LayoutOption
    ((LayoutOption--));
    #If option extist keep going, if not repeat
    if [[ "${ArrLayout[$LayoutOption]}" == qwerty ]]; then
        sed -i 'echo "exec \"setxkbmap us -variant KEYBOARDLAYOUT\"\" >> /etc/i3/config' archinstaller/archinstall.sh
        sed -i 's/KEYBOARDLAYOUT/ /' archinstaller/archinstall.sh
        break
    elif [[ "${ArrLayout[$LayoutOption]}" == colemak ]]; then
        sed -i 's/KEYBOARDLAYOUT/colemak/' archinstaller/archinstall.sh
        break
    elif [[ "${ArrLayout[$LayoutOption]}" == colemak ]]; then
        sed -i 's/KEYBOARDLAYOUT/dvorak/' archinstaller/archinstall.sh
        break
    else
        echo -e "Please select an available option"
        #Restart counter
        unset CounterArray
    fi
done

# Adding more paralleldownloads
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 8/" /etc/pacman.conf

# Use timedatectl to ensure the system clock is accurate:
timedatectl set-ntp true

# Disk formating and mounting
read -p "Do you want to format and partition your disk? (y/n): " CONFIRMATION
if [ "$CONFIRMATION" = "y" ]; then

    # Partitioning the disks
    cfdisk 
    printf "\033c"

    # To find all disk available
    ArrStoragePath=( $(lsblk -np --output KNAME) )

    # Arch partition
    lsblk
    echo -e "\n----------------------------------------------\n"
    while true; do
        # Loop to display disks
        echo -e "Choose one option: "
        for item in "${ArrStoragePath[@]}"
        do
            ((CounterArray++))
            echo -e " $CounterArray) $item"
        done
        read -p "Select the /dev/drive (number) where ARCH will be used ->  " ospartition
        ((ospartition--))
        # If option extist keep going, if not repeat
        if [ -n "${ArrStoragePath[$ospartition]}" ]; then
            # Formating and mounting the partition
            mkfs.ext4 ${ArrStoragePath[$ospartition]}
            mount ${ArrStoragePath[$ospartition]} /mnt
            # Delete item after selected
            unset ArrStoragePath[$ospartition]
            ArrStoragePath=( "${ArrStoragePath[@]}" )
            # Restart counter
            unset CounterArray
            break
        else
            printf "\033c"
            echo -e "\n ----------------------------------- "
            echo -e "| Please select an available option |"
            echo -e " ----------------------------------- \n"
            unset CounterArray
        fi
    done

    # EFI or bios partition
    echo -e "\n---------------------------------------------------------------------------------"
    read -p "Did you create an arguments\"EPI or BIOS partition\"? (y/n): " CONFIRMATION
    echo -e "\n---------------------------------------------------------------------------------"
    if [ "$CONFIRMATION" = "y" ]; then

        printf "\033c"
        lsblk
        echo -e "\n----------------------------------------------\n"
        while true; do
            # Loop to display disks
            echo -e "Choose one option: "
            for item in "${ArrStoragePath[@]}"
            do
                ((CounterArray++))
                echo -e " $CounterArray) $item"
            done
            read -p "Select the /dev/drive (number) where the BOOTLOADER will be used -> " bootpartition
            ((bootpartition--))
            # If option extist keep going, if not repeat
            if [ -n "${ArrStoragePath[$bootpartition]}" ]; then
                # Formating and mounting the partition
                mkfs.fat -F 32 ${ArrStoragePath[$bootpartition]}
                mkdir /mnt/boot
                mount ${ArrStoragePath[$bootpartition]} /mnt/boot
                # Delete item after selected
                unset ArrStoragePath[$bootpartition]
                ArrStoragePath=( "${ArrStoragePath[@]}" )
                # Restart counter
                unset CounterArray
                break
            else
                printf "\033c"
                echo -e "\n ----------------------------------- "
                echo -e "| Please select an available option |"
                echo -e " ----------------------------------- \n"
                unset CounterArray
            fi
        done
    fi

    # EFI or bios partition
    read -p "Did you create a SWAP partition? (y/n): " CONFIRMATION
    echo -e "\n---------------------------------------------------------------------------------"
    if [ "$CONFIRMATION" = "y" ]; then

        printf "\033c"
        lsblk
        echo -e "\n----------------------------------------------\n"
        while true; do
            # Loop to display disks
            echo -e "Choose one option: "
            for item in "${ArrStoragePath[@]}"
            do
                ((CounterArray++))
                echo -e " $CounterArray) $item"
            done
            echo -e "\n------------------------------------------------------------------------------"
            read -p "Select the /dev/drive (number) where the SWAP will be used -> " swappartition
            echo -e "\n------------------------------------------------------------------------------"
            ((swappartition--))
            # If option extist keep going, if not repeat
            if [ -n "${ArrStoragePath[$swappartition]}" ]; then
                # Formating and mounting the partition
                mkfs.fat -F 32 ${ArrStoragePath[$swappartition]}
                mkdir /mnt/boot
                mount ${ArrStoragePath[$swappartition]} /mnt/boot
                # Formating and mounting the partition
                mkswap ${ArrStoragePath[$swappartition]}
                swapon ${ArrStoragePath[$swappartition]}
                # Delete item after selected
                unset ArrStoragePath[$swappartition]
                ArrStoragePath=( "${ArrStoragePath[@]}" )
                # Restart counter
                unset CounterArray
                break
            else
                printf "\033c"
                echo -e "\n ----------------------------------- "
                echo -e "| Please select an available option |"
                echo -e " ----------------------------------- \n"
                unset CounterArray
            fi
        done
    fi

fi

# Use the pacstrap script to install the base package, Linux kernel and firmware for common hardware:
echo -e "\nUsing the pacstrap script to install the base package, Linux kernel and firmware for common hardware"
pacstrap /mnt base linux linux-firmware vim sed

# Generating an fstab file (use -U or -L to define by UUID or labels, respectively), in this case using -U
genfstab -U /mnt >> /mnt/etc/fstab

# With sed, cutting this script until #chrootpart to execute it later from /mnt in chroot mode
echo -e "\nUsing sed, cutting this script until #chrootpart to execute it later from /mnt in chroot mode"
sed '1,/^#chrootpart$/d' archinstaller/archinstall.sh > /mnt/archinstallpart2.sh
chmod +x /mnt/archinstallpart2.sh

# Changing to chroot
arch-chroot /mnt ./archinstallpart2.sh
exit

#chrootpart
#```````````````----------------------------------------------------------------------```````````````
#```````````````------------------------------ PART 2 --------------------------------```````````````
#```````````````------------------- Adding HOST, USERS and software ------------------```````````````
#```````````````----------------------------------------------------------------------```````````````

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

# setting KEYBOARDLAYOUT as a main layout
echo -e "KEYMAP=KEYBOARDLAYOUT" >> /etc/vconsole.conf

# creatinzathurag hostname
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
pacman -S --noconfirm mtools dosfstools base-devel linux-headers openssh curl man-db
## Windows system display
pacman -S --noconfirm xorg xorg-server xorg-xinit xorg-xbacklight
## Window manager
pacman -S --noconfirm i3-gaps dmenu nitrogen i3status
## Gnome
pacman -S --noconfirm gnome gdm
## Fonts
pacman -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome
## Grub stuff
pacman -S --noconfirm grub efibootmgr os-prober
## bluetooth
pacman -S --noconfirm bluez bluez-utils blueman pulseaudio-bluetooth pavucontrol
## Wifi
pacman -S --noconfirm networkmanager network-manager-applet wireless_tools wpa_supplicant
## Software of my preference
pacman -S --noconfirm tilix kitty firefox simplescreenrecorder obs-studio vlc papirus-icon-theme git \
    picom nitrogen feh pcmanfm ranger rofi zsh most lxappearance neofetch \
    zathura zathura-pdf-mupdf ffmpeg imagemagick \
    zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl \
    arandr thunar htop bashtop stow rsync\

# Enabling software
systemctl enable NetworkManager
systemctl enable gdm.service
systemctl start gdm.service
localectl set-keymap KEYBOARDLAYOUT

# Create your root password
echo -e "\n-------------------------------------------------"
echo -e "Insert your PASSWORD for ROOT (AKA SUDO PASSWORD)"
passwd

# Create your user
echo -e "\n---------------------------------------------------------------"
echo -e "Insert your USERNAME (yes your username, will be added in wheel group)"
read -p "--> " CREATEDUSERNAME
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
useradd -mG wheel -s /bin/zsh $CREATEDUSERNAME

# Create a password for your user
echo -e "\n--------------------------------------"
echo -e "Insert the PASSWORD of $CREATEDUSERNAME"
echo -e "Insert the PASSWORD of $CREATEDUSERNAME"
passwd $CREATEDUSERNAME

# Verifying if is EFI or not to install GRUB
echo -e "\n--------------------------------------"
echo -e "Verifing if is EFI or not..."
if [ -d /sys/firmware/efi ]; then
    echo -e "Installing GRUB in UEFI\n"
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
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

# With sed, cutting this script until userpartchrootpart to execute it in the user
USERPATH=/home/$CREATEDUSERNAME/archinstallpart3.sh
sed '1,/^#userpart$/d' archinstallpart2.sh > $USERPATH
chown $CREATEDUSERNAME:$CREATEDUSERNAME $USERPATH
chmod +x $USERPATH
su -c $USERPATH -s /bin/sh $CREATEDUSERNAME

# Putting sudo with password again, simple replace
sed -i 's/%wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers

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

# Setting my keyboard again as a KEYBOARDLAYOUT
setxkbmap -layout us KEYBOARDLAYOUT
echo "exec \"setxkbmap us -variant KEYBOARDLAYOUT\"" >> /etc/i3/config
# Installing yay
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
# Software needed for dotfiles:
# Installing package with yay
yay -Syy
yay -S cava dunst mpd ncmpcpp polybar papirus-nord picom pywal-git feh visual-studio-code-bin \
    nerd-fonts-roboto-mono p7zip-gui networkmanager-dmenu-git github-cli google-chrome
# Polybar Themes
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes
chmod +x setup.sh
./setup.sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended