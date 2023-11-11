#!/bin/bash

# Update the system
echo "Updating the system..."
pacman -Syu

# Clone the AUR package for Plymouth
echo "Cloning the AUR package for Plymouth..."
git clone https://aur.archlinux.org/plymouth.git

# Change into the plymouth directory
cd plymouth

# Build and install the package
echo "Building and installing Plymouth..."
makepkg -si

# Change back to the home directory
cd ..

# Configure Plymouth
echo "Configuring Plymouth..."
plymouth-set-default-theme -R spinner

# Enable Plymouth
echo "Enabling Plymouth..."
systemctl enable plymouth-start.service
systemctl enable plymouth-quit.service
systemctl enable plymouth-quit-wait.service

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 7.sh > /mnt/install7.sh
    chmod +x /mnt/install7.sh
    arch-chroot /mnt ./install7.sh
    exit
}
