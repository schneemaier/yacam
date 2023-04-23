#!/bin/sh
# Verify if Wifi is connected and reboot system if there is no connection for 300 seconds

NOTCONNECTEDSECONDS=0

# check if AP mode. Only run if it is not in AP mode

while true
do
	sleep 5
	if [[ `cat /sys/class/net/wlan0/carrier` -eq "0" ]]
	then
		# Not connected
		NOTCONNECTEDSECONDS=$((NOTCONNECTEDSECONDS+5))
	else
		# Connected
		NOTCONNECTEDSECONDS=0
	fi
	echo $NOTCONNECTEDSECONDS
	if [[ $NOTCONNECTEDSECONDS -gt 300 ]]
	then
		echo "Time for reboot"
		reboot
	fi
done
