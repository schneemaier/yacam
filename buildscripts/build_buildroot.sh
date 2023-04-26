#!/bin/bash
set -e

case $1 in
  '64')
    # Xiaofang 1S 64M
    export SET64=1
    export NET="FS"
    ;;
  'PAN')
    # Wyze Pan V1
    export SET64=0
    export NET='ES'
    ;;
  '128')
    # Wyze V2
    export SET64=0
    export NET='FS'
    ;;
  *)
    # Wyze V2
    export SET64=0
    export NET='FS'
    ;;
esac

# This script is expected to be run inside the development container
# It copies from /src files that have been changed for buildroot purposes

cd /yacam/build/buildroot-2016.02

# Copy over custom packages removing standard ones we don't want to use

# ffmpeg doesn't seem to build out of the box so use our own
rm -rf /yacam/build/buildroot-2016.02/package/ffmpeg


# Use our own mjpg-streamer package
rm -rf /yacam/build/buildroot-2016.02/package/mjpg-streamer

# Old ncurses doesn't support xterm-256color so use updated one
rm -rf /yacam/build/buildroot-2016.02/package/ncurses

rm -rf /yacam/build/buildroot-2016.02/package/lighttpd

rm -rf /yacam/build/buildroot-2016.02/package/logrotate

rm -rf /yacam/build/buildroot-2016.02/package/wpa_supplicant

cp -r /src/custompackages/package/* /yacam/build/buildroot-2016.02/package/

# Avoid FPU bug on XBurst CPUs
#patch -p1 < /src/patches/add_fp_no_fused_madd.patch

# Video for Linux package needs -lpthread (only needed if I compile it)
#patch -p1 < /src/patches/libv4l_add_lpthread.patch

# Add LINUX_PRE_BUILD_HOOKS to create embedded initramfs file
#patch -p1 < /src/patches/linux_makefile.patch

# Replace the default buildroot config files with our custom ones
# The linux configuration is set inside the ingenic_t20_defconfig
# using BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE

if [[ "$SET64" == "0" ]]
then
  cp /src/config/ingenic_t20_defconfig configs/
else
  cp /src/config/ingenic_t20_64_defconfig configs/
fi
cp /src/config/busybox.config package/busybox
cp /src/config/uClibc-ng.config package/uclibc


# We want to use specific sources so copy these into the download directory
mkdir -p dl
cp /src/kernel_sources/kernel-3.10.14.tar.xz dl/

# Loads up our custom configuration
if [[ "$SET64" == "0" ]]
then
  make ingenic_t20_defconfig
else
  make ingenic_t20_64_defconfig
fi

# We just loaded it but these commands are how you save it back (here for reference)
# Technically should be a no-op
# make savedefconfig BR2_DEFCONFIG=/src/config/ingenic_t20_defconfig
# make linux-update-defconfig

# Start the build process
cd /yacam/build/buildroot-2016.02

echo "Set64="$SET64
echo "Net="$NET

make

