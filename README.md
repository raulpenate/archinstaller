# Arch Installer

This repository provides a simple script to install Arch Linux with ease. 

Follow the instructions below to get started.

### Features:
- Automatically detects between `EFI` and `BIOS` before installing `grub`.
- Uses `ext4` by default, creating the `boot` and `os` partitions, with an optional `swap`.
- Comes with `i3 gaps`, `plasma`, and `gnome`, plus many basic utilities such as `bluetooth`, `network`, `htop`, `ranger`, etc.
- You can customize the `.dotfiles` you want to install.
- You can select between **QWERTY**, **AZERTY**, and **COLEMAK** layouts.
- Just select the desired options.
- You don't have to write the whole code by hand.

## Installation Steps

https://github.com/user-attachments/assets/582d2b1b-1cdf-4fa4-8973-e211b6efd493

1. **Update Package Database and Install Required Packages**

   Run the following command to update the package database and install `git` and `vim`:

   ```bash
   pacman -Syy git vim
   ```

2. **Clone the Repository**

   Clone the Arch Installer repository to your local machine:

   ```bash
   git clone https://github.com/raulpenate/archinstaller
   ```

3. **Navigate to the Directory**

   Change into the cloned directory:

   ```bash
   cd archinstaller
   ```

4. **Make the Installer Script Executable**

   Run the following command to give execution permissions to the installer script:

   ```bash
   chmod +x archinstall.sh
   ```

5. **Run the Installer Script**

   Finally, execute the installer script:

   ```bash
   ./archinstall.sh
   ```

## Usage

Follow the prompts provided by the installer script to set up your Arch Linux system.

## Contributing

If you would like to contribute to this project, feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

Thanks to the Arch Linux community for their support and documentation.