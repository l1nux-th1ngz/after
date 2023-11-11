#!/bin/bash

# Disk partitioning
partition_disk () {
    disk=$(whiptail --inputbox "Enter the disk to partition (e.g., /dev/sda)" 10 60 --title "Disk Partitioning" 3>&1 1>&2 2>&3)
    (echo o; echo n; echo p; echo 1; echo ; echo ; echo a; echo w) | sudo fdisk $disk
}

# Filesystem creation
create_filesystem () {
    filesystem=$(whiptail --menu "Choose a filesystem" 15 60 4 "1" "ext4" "2" "xfs" "3" "btrfs" 3>&1 1>&2 2>&3)
    case $filesystem in
        "1") sudo mkfs.ext4 ${disk}1 ;;
        "2") sudo mkfs.xfs ${disk}1 ;;
        "3") sudo mkfs.btrfs ${disk}1 ;;
    esac
}

# Mount root partition
mount_partition () {
    sudo mount ${disk}1 /mnt
}

# Install base system
install_base () {
    sudo pacstrap /mnt --noconfirm base base-devel multilib-devel git xdg-user-dirs xdg-user-dirs-gtk rustup zenity
}

# Generate fstab
generate_fstab () {
    sudo genfstab -U /mnt >> /mnt/etc/fstab
}

# Change root into new system
chroot_system () {
    sudo arch-chroot /mnt
}

# Update xdg-user-dirs
update_xdg_dirs () {
    xdg-user-dirs-update
}

# Setup Rust
setup_rust () {
    if [ ! -d "$HOME/.cargo" ]; then
        mkdir "$HOME/.cargo"
    fi
    source "$HOME/.cargo/env"
    rustup default stable
}

# Install yay and paru from AUR
install_aur_helpers () {
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
}

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 1.sh > /mnt/install1.sh
    chmod +x /mnt/install1.sh
    arch-chroot /mnt ./install1.sh
    exit
}

# Installation steps
partition_disk
create_filesystem
mount_partition
install_base
generate_fstab
chroot_system
update_xdg_dirs
setup_rust
install_aur_helpers
move_to_next_phase

###Next Phase Starts Now##