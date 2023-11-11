#!/bin/bash

# Update the package lists
yay -Syu --noconfirm

# Install Thunar
yay -S thunar --noconfirm --needed

# Install Thunar plugins
yay -S thunar-archive-plugin thunar-media-tags-plugin thunar-vcs-plugin --noconfirm --needed

# Create a custom action to open folders as root
mkdir -p ~/.config/Thunar
echo '[Desktop Entry]
Version=1.0
Type=Application
Exec=thunar admin://%f
Icon=Thunar
StartupNotify=true
Terminal=false
Categories=System;FileManager;
MimeType=inode/directory;
Name=Open as admin
Comment=Open folder as root
Icon=system-file-manager
Terminal=false
StartupNotify=true
Type=Application
Categories=FileManager;Utility;GTK;
MimeType=inode/directory;application/x-gnome-saved-search;
Actions=Window;
NoDisplay=true
Keywords=folder;manager;explore;disk;filesystem;
' > ~/.config/Thunar/uca.xml

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 8.sh > /mnt/install8.sh
    chmod +x /mnt/install8.sh
    arch-chroot /mnt ./install8.sh
    exit
}
