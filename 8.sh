#!/bin/bash

# Define the packages to install
packages=("fish" "zsh" "git" "curl")

# Install the packages
for pkg in "${packages[@]}"; do
    if ! pacman -Qq | grep -qw "$pkg"; then
        yay -S --noconfirm --needed "$pkg"
    else
        echo "$pkg is already installed, skipping..."
    fi
done

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed, skipping..."
fi

# Define the plugins to install
plugins=("git" "zsh-autosuggestions" "zsh-syntax-highlighting")

# Install the plugins
for plugin in "${plugins[@]}"; do
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin" ]; then
        git clone https://github.com/zsh-users/$plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/$plugin
    else
        echo "$plugin is already installed, skipping..."
    fi
done

# Enable the plugins in .zshrc
for plugin in "${plugins[@]}"; do
    if ! grep -q "$plugin" "$HOME/.zshrc"; then
        sed -i.bak "/plugins=(/a \ \ $plugin" "$HOME/.zshrc"
    else
        echo "$plugin is already enabled in .zshrc, skipping..."
    fi
done

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 9.sh > /mnt/install9.sh
    chmod +x /mnt/install9.sh
    arch-chroot /mnt ./install9.sh
    exit
}
