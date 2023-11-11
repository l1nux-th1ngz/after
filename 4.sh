#!/bin/bash

packages=("waland-git" "wayland-protocols-git" "wayland-utils-git" "hyprland-git" "wlroots-git" "xdg-user-dir" "xdg-user-dirs-gtk" "xdg-user-dirs-update" "xdg-user-dirs-gtk-update" "dunst" "kitty" "alacrity" "ranger" "polkit-kde-agent" "firefox" "rofi" "wofi" "xdg-desktop-portal-hyprland-git" "xdg-desktop-portal-wlr-git" "xdg-desktop-portal-gtk-git" "waybar-hyprland-git" "qt5-wayland" "qt6-wayland" "pipewire" "wireplumber")

for pkg in "${packages[@]}"; do
    if ! pacman -Qq | grep -qw "$pkg"; then
        yay -S --noconfirm "$pkg"
    else
        echo "$pkg is already installed, skipping..."
    fi
done

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 5.sh > /mnt/install5.sh
    chmod +x /mnt/install5.sh
    arch-chroot /mnt ./install5.sh
    exit
}
