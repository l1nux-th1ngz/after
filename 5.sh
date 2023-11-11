#!/bin/bash

apps1=("mako" "cliphist" "clipman" "udiskie" "udisks2" "google-chrome" "vivaldi" "marker" "typhora")
apps2=("ffmpeg" "ffmpegthumbnailer" "ffmpegthumbs" "vivaldi-ffmpeg-codecs" "python-adblock" "brave-bin" "chromium" "ascii" "aalib" "jp2a" "imv")
apps3=("jq" "i2pd" "mpd" "mpc" "spotify" "cantata" "playerctl" "brightnessctl" "vlc" "spotify-adblock-git")
apps4=("gdb" "ninja" "gcc" "cmake" "meson" "libxcb" "xcb-proto" "xcb-util" "xcb-util-keysyms" "libxfixes" "libx11")
apps5=("libxcomposite" "xorg-xinput" "libxrender" "pixman" "cairo" "pango" "seatd" "libxkbcommon" "xcb-util-wm" "xorg-xwayland" "libinput" "libliftoff" "libdisplay-info" "cpio")

install_apps() {
    for app in "$@"; do
        yay -S --noconfirm --needed "$app"
    done
}

verify_apps() {
    for app in "$@"; do
        if ! command -v "$app" &> /dev/null; then
            echo "$app could not be verified as installed."
            unverified_apps+=("$app")
        fi
    done
}

install_apps "${apps1[@]}"
verify_apps "${apps1[@]}"

install_apps "${apps2[@]}"
verify_apps "${apps2[@]}"

install_apps "${apps3[@]}"
verify_apps "${apps3[@]}"

install_apps "${apps4[@]}"
verify_apps "${apps4[@]}"

install_apps "${apps5[@]}"
verify_apps "${apps5[@]}"

# Moving to next phase
move_to_next_phase () {
    sed '1,/^###part$/d' 6.sh > /mnt/install6.sh
    chmod +x /mnt/install6.sh
    arch-chroot /mnt ./install6.sh
    exit
}