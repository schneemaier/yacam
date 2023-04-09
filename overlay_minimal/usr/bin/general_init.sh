#!/bin/sh
set -x

# Create log symlink, but delete the exisitng one first
# this symlink is removed from the root filesystem
rm /var/log
ln -s /tmp /var/log

. /usr/bin/libgpio.sh
gpio_select_gpiochip 0

SD_PARTITION=/dev/mmcblk0p1
SD_FILESYSTEM=vfat
YACAM_CONFIG_FILE=/sdcard/config/overlay/etc/yacam.conf

logger -s -t general_init "Setting up SDCard access"

setup_sdcard_access() {
	mkdir -p /sdcard
	# mount -t vfat $SD_PARTITION /sdcard -o rw,umask=0000,dmask=0000
	mount -t $SD_FILESYSTEM $SD_PARTITION /sdcard -o rw
	sleep 1
	echo "Mount /sdcard successful"

	# Write log files to the sdcard
	mkdir -p /sdcard/var/log

	# Current state is /var/log -> ../tmp
	# At this point /tmp is empty (not sure why)
	rm /var/log
	ln -s /sdcard/var/log /var/log
}

# Determine if sdcard access needs to be setup
# On WyzeCam Pan units the /dev/mmcblk0p1 is available without having
# to export pin 43. However on WyzeCams you need to export 43
# for the mmc devices to show up

if [ -e $SD_PARTITION ]; then
	setup_sdcard_access
else
	# If the device doesn't exist then either the sdcard is not present or we need to export the pin
	gpio_export '43'
	gpio_direction_output '43'
	sleep 3

	# If after exporting the device exists then setup
	if [ -e $SD_PARTITION ]; then
		setup_sdcard_access
	else
		# If it still doesn't exist then unexport and continue
		gpio_unexport '43'
	fi;
fi;

# Not sure why this is needed, will remove later
if [[ -f $YACAM_CONFIG_FILE ]]; then
	. $YACAM_CONFIG_FILE
fi

clear_config_partition() {
	if [[ "$CLEAR_CONFIG_PARTITION" == "1" ]]; then
		echo "Wiping /config"
		rm -rf /config/overlay/*
		echo "Wipe complete. Make sure you remove the CLEAR_CONFIG_PARTITION flag."
	fi
}
clear_config_partition

if [ -f "/sdcard/yacam.conf" ]
then
	logger -s -t general_init "Copying yacam.conf from sdcard to flash storage"
	cat /sdcard/yacam.conf >> /etc/yacam.conf
	logger -s -t general_init "Config copied from sdcard"
fi

logger -s -t general_init "Genral Init done."
