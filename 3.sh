#!/bin/bash

# Install fcitx5-gtk
yay -S fcitx5-gtk --noconfirm

# Install fcitx5 5t5&qt6
yay -S fcitx5-qt5 --noconfirm
yay -S fcitx-qt6 --noconfirm

# Create a configuration file for fcitx5
mkdir -p ~/.config/fcitx5
echo -e "[InputMethod]\n# Specify the comma-separated list of input method in order\nDefaultLayout=us\n# Available: True, False\nEnable=False\n# Available: True, False\nIMSelectorVisible=True" > ~/.config/fcitx5/profile

# Add environment variables to bashrc
echo -e "\n# Fcitx5 Configuration\nexport GTK_IM_MODULE=fcitx5\nexport QT_IM_MODULE=fcitx5\nexport XMODIFIERS=@im=fcitx5" >> ~/.bashrc

# Source bashrc
source ~/.bashrc

# Restart fcitx5 service
pkill fcitx5 && nohup fcitx5 &

#!/bin/sh

# variables
bordercolor="#303030"
border=5
image="/tmp/image.png"
icon="/tmp/icon.png"

grim -g "$(slurp -p)" - > $image
hexcode=$(magick $image -colors 1 txt: | awk 'NR==2 {print $3}')
magick convert $image -filter point -resize 96x96 -bordercolor $bordercolor -border $border $icon
notify-send -i $icon "  rang" "The hex code is $hexcode"
wl-copy -n $hexcode
rm -f $image $icon

#!/bin/sh

cd ~

# Log WLR errors and logs to the hyprland log. Recommended
export HYPRLAND_LOG_WLR=1

# Tell XWayland to use a cursor theme
export XCURSOR_THEME=Bibata-Modern-Classic

# Set a cursor size
export XCURSOR_SIZE=24

# Example IME Support: fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

exec Hyprland

# Moving to next phase
###Next Phase Starts Now##
move_to_next_phase () {
    sed '1,/^###part$/d' 3.sh > /mnt/install3.sh
    chmod +x /mnt/install3.sh
    arch-chroot /mnt ./install3.sh
    exit
}
I apologize for the confusion. Here is the corrected script with the IME support settings for `fcitx`, the execution of `Hyprland`, and the `move_to_next_phase` function. I've also removed the blank lines:

```bash
#!/bin/bash
# Install fcitx5-gtk
yay -S fcitx5-gtk --noconfirm
# Install fcitx5 5t5&qt6
yay -S fcitx5-qt5 --noconfirm
yay -S fcitx-qt6 --noconfirm
# Create a configuration file for fcitx5
mkdir -p ~/.config/fcitx5
echo -e "[InputMethod]\n# Specify the comma-separated list of input method in order\nDefaultLayout=us\n# Available: True, False\nEnable=False\n# Available: True, False\nIMSelectorVisible=True" > ~/.config/fcitx5/profile
# Add environment variables to bashrc
echo -e "\n# Fcitx5 Configuration\nexport GTK_IM_MODULE=fcitx5\nexport QT_IM_MODULE=fcitx5\nexport XMODIFIERS=@im=fcitx5" >> ~/.bashrc
# Source bashrc
source ~/.bashrc
# Restart fcitx5 service
pkill fcitx5 && nohup fcitx5 &
# variables
bordercolor="#303030"
border=5
image="/tmp/image.png"
icon="/tmp/icon.png"
grim -g "$(slurp -p)" - > $image
hexcode=$(magick $image -colors 1 txt: | awk 'NR==2 {print $3}')
magick convert $image -filter point -resize 96x96 -bordercolor $bordercolor -border $border $icon
notify-send -i $icon "  rang" "The hex code is $hexcode"
wl-copy -n $hexcode
rm -f $image $icon
cd ~
# Log WLR errors and logs to the hyprland log. Recommended
export HYPRLAND_LOG_WLR=1
# Tell XWayland to use a cursor theme
export XCURSOR_THEME=Bibata-Modern-Classic
# Set a cursor size
export XCURSOR_SIZE=24
# IME Support: fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
exec Hyprland
# Moving to next phase
###Next Phase Starts Now##
move_to_next_phase () {
    sed '1,/^###part$/d' 3.sh > /mnt/install4.sh
    chmod +x /mnt/install4.sh
    arch-chroot /mnt ./install4.sh
    exit
}