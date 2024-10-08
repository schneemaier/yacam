#!/bin/sh

NIGHTVISION_FILE="/tmp/night_vision_enabled"

. /etc/yacam.conf
. /usr/bin/libgpio.sh
gpio_select_gpiochip 0

case $1 in
	on)
		echo "$(date) - nightmode on"
		if [ "$ENABLE_IR_LED" == "1" ]
		then
			gpio_set_value 49 1
		else
			gpio_set_value 49 0
		fi
		gpio_set_value 26 0
		gpio_set_value 25 1
		echo "1" > $NIGHTVISION_FILE
		sleep 1
		gpio_set_value 25 0
		;;
	off)
		echo "$(date) - nightmode off"
		gpio_set_value 49 0
		gpio_set_value 25 0
		gpio_set_value 26 1
		echo "0" > $NIGHTVISION_FILE
		sleep 1
		gpio_set_value 26 0
		;;
	*)
		;;
esac

