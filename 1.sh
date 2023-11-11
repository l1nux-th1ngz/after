#!/bin/bash

# Backup current grub settings
sudo cp /etc/default/grub /etc/default/grub.bak

# Write new grub settings
cat << EOF | sudo tee /etc/default/grub
# Load partition table and file system modules
insmod part_gpt
insmod fat
insmod iso9660
insmod ntfs
insmod ntfscomp
insmod exfat
insmod udf

# Use graphics-mode output
if loadfont "${prefix}/fonts/unicode.pf2" ; then
    insmod all_video
    set gfxmode="auto"
    terminal_input console
    terminal_output console
fi

# Enable serial console
insmod serial
insmod usbserial_common
insmod usbserial_ftdi
insmod usbserial_pl2303
insmod usbserial_usbdebug
if serial --unit=0 --speed=115200; then
    terminal_input --append serial
    terminal_output --append serial
fi

# Search for the ISO volume
if [ -z "${ARCHISO_UUID}" ]; then
    if [ -z "${ARCHISO_HINT}" ]; then
        regexp --set=1:ARCHISO_HINT '^\(([^)]+)\)' "${cmdpath}"
    fi
    search --no-floppy --set=root --file '%ARCHISO_SEARCH_FILENAME%' --hint "${ARCHISO_HINT}"
    probe --set ARCHISO_UUID --fs-uuid "${root}"
fi

# Get a human readable platform identifier
if [ "${grub_platform}" == 'efi' ]; then
    archiso_platform='UEFI'
    archiso_platform="${grub_cpu} ${archiso_platform}"
else
    archiso_platform="${grub_cpu} ${grub_platform}"
fi

# Set default menu entry
default=Arch
timeout=0
timeout_style=hidden


# Menu entries

menuentry "Arch Linux (%ARCH%, ${archiso_platform})" --class arch --class gnu-linux --class gnu --class os --id 'archlinux' {
    set gfxpayload=keep
    linux /%INSTALL_DIR%/boot/%ARCH%/vmlinuz-linux archisobasedir=%INSTALL_DIR% archisodevice=UUID=${ARCHISO_UUID}
    initrd /%INSTALL_DIR%/boot/%ARCH%/initramfs-linux.img
}

if [ "${grub_platform}" == 'efi' -a -f '/boot/memtest86+/memtest.efi' ]; then
    menuentry 'Run Memtest86+ (RAM test)' --class memtest86 --class gnu --class tool {
        GRUB_GFXMODE=1920x1080
GRUB_GFXPAYLOAD_LINUX=keep
        linux /boot/memtest86+/memtest.efi
    }
fi

if [ "${grub_platform}" == 'efi' ]; then
    if [ -f '/shellx64.efi' ]; then
        menuentry 'UEFI Shell' {
            chainloader /shellx64.efi
        }
    fi

EOF

# Update grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Moving to next phase
###Next Phase Starts Now##
move_to_next_phase () {
    sed '1,/^###part$/d' 2.sh > /mnt/install2.sh
    chmod +x /mnt/install2.sh
    arch-chroot /mnt ./install2.sh
    exit
}
