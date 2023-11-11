#!/bin/bash

# Define variables
GREEN="$(tput setaf 2)[OK]$(tput sgr0)"
RED="$(tput setaf 1)[ERROR]$(tput sgr0)"
YELLOW="$(tput setaf 3)[NOTE]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
LOG="install.log"

# Set the script to exit on error
set -e

printf "$(tput setaf 2) Arch installer!\n $(tput sgr0)"

sleep 2

printf "$YELLOW PLEASE BACKUP YOUR FILES BEFORE PROCEEDING!
This script will overwrite some of your configs and files!"

sleep 2

printf "\n
$YELLOW  Some commands requires you to enter your password inorder to execute
If you are worried about entering your password, you can cancel the script now with CTRL Q or CTRL C and review contents of this script. \n"

sleep 3

# Is yay(||)paru is installed?
ISyay=/usr/bin/yay

if [ -f "$ISyay" ]; then
    printf "\n%s - yay was located, moving on.\n" "$GREEN"
else 
    printf "\n%s - yay was NOT located\n" "$YELLOW"
    read -n1 -rep "${CAT} Would you like to install yay (Y)" INST
    if [[ $INST =~ ^[Y]$ ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm 2>&1 | tee -a $LOG
        cd ..
    else
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si --noconfirm 2>&1 | tee -a $LOG
        cd ..
    fi
    # update system before proceed
    printf "${YELLOW} System Update to avoid issue\n" 
    yay -Syu --noconfirm 2>&1 | tee -a $LOG
fi

# Function to print error messages
print_error() {
    printf " %s%s\n" "$RED" "$1" "$NC" >&2
}

# Function to print success messages
print_success() {
    printf "%s%s%s\n" "$GREEN" "$1" "$NC"
}


### Install packages ####
read -n1 -rep "${CAT} Would you like to install the packages? (Y)" inst
echo

if [[ $inst =~ ^[Nn]$ ]]; then
    printf "${YELLOW} No packages installed. Goodbye! \n"
            exit 1
        fi

if [[ $inst =~ ^[Y]$ ]]; then
   yay -S --noconfirm "grimblast-git waybar-hyprland-git" \
     "waland-git" "wayland-protocols-git" "wayland-utils-git" "hyprland-git" "wlroots-git" "xdg-user-dir" "xdg-user-dirs-gtk" \
     "xdg-user-dirs-update" "xdg-user-dirs-gtk-update" "dunst" "kitty" "alacrity" "ranger" "polkit-kde-agent" "firefox" "rofi" "wofi" \
     "xdg-desktop-portal-hyprland-git" "xdg-desktop-portal-wlr-git" "xdg-desktop-portal-gtk-git" "waybar-hyprland-git" "qt5-wayland"
      "qt6-wayland" "pipewire" "wireplumber"
     "mako" "cliphist" "clipman" "udiskie" "udisks2" "google-chrome" "vivaldi" "marker" "typhora"
     "ffmpeg" "ffmpegthumbnailer" "ffmpegthumbs" "vivaldi-ffmpeg-codecs" "python-adblock" "brave-bin" "chromium" "ascii" "aalib" "jp2a" "imv"
      "jq" "i2pd" "mpd" "mpc" "spotify" "cantata" "playerctl" "brightnessctl" "vlc" "spotify-adblock-git"
     "gdb" "ninja" "gcc" "cmake" "meson" "libxcb" "xcb-proto" "xcb-util" "xcb-util-keysyms" "libxfixes" "libx11"
      "libxcomposite" "xorg-xinput" "libxrender" "pixman" "cairo" "pango" "seatd" "libxkbcommon" "xcb-util-wm"
       "xorg-xwayland" "libinput" "libliftoff" "libdisplay-info" "cpio"
   "ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font otf-sora ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa"
   "ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd adobe-source-code-pro-fonts"
   "nwg-look-bin qt5ct btop jq gvfs ffmpegthumbs swww mousepad mpv  playerctl pamixer noise-suppression-for-voice"
   "polkit-gnome ffmpeg neovim viewnior pavucontrol thunar ffmpegthumbnailer xdg-user-dirs-gtk xdg-user-dirs"
   "nordic-theme papirus-icon-theme starship " 

    yay -R --noconfirm swaylock waybar
    fi
    xdg-user-dirs-update     xdg-user-dirs-gtk-update

    echo
    print_success " All necessary packages installed successfully."

else
    echo
    print_error " Packages not installed - please check the install.log"
    sleep 1
fi


### Copy Config Files ###
read -n1 -rep "${CAT} Would you like to copy config files? (y,n)" CFG
if [[ $CFG =~ ^[Yy]$ ]]; then
    printf " Copying config files...\n"
    cp -r dotconfig/dunst ~/.config/ 2>&1 | tee
fi
