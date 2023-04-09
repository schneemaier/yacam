# YaCAM

YaCAM is a custom opensource firmware for Wyze cameras that use the Ingenic T20 chip. Currently it is tested with Wyze V2 cameras with 128MB memory. I may work on others, but it is untested. Use it at your own risk.
The firmeware is based mainly on openmiko, but some ideas are from other places like DaFang Hacks / OpenFang / OpenIPC.

## Features

1. Can provide rtsp and mjpg streams
2. Bash http server for basic configuration
3. AP mode for initial configuration of the WIFI conntion
4. Single config file


## Differences from openmiko

The main difference that this project uses squashfs, overlayfs and jffs2. Things like micropython are removed to save space and make it compatible with the original fimrware update metode. 

## For end users

This firmware is not yet ready for daily use!!!!


## Overview

TBD

## Installation and Usage

1. Put the demo.bon file on an SD card with FAT file system (Suggestion to use a partition <1GB)
2. Power up the camera while holding the setup button (~30 seconds)
3. Flashing takes arouns 1-2 minutes
4. After 2 minutes search for the YACAM AP on your phone or tablet. The AP is YaCAM+MAC address of the WIFI chip. If nothing happens camera will autoreboot in ~5 minutes.
5. When WIFI is connected go to 192.168.4.1 with the browser on the phone
6. Provide SSID and WPA password (Hidden SSID or none WPA authetication is currently not supported)
7. After save the camera will reboot and connect to the WIFI

## Usage

1. Connect to the camera at http://camera_IP:8080/?action=stream for the MJPEG stream
2. Connect to the camera at http://camera_IP:8080/?action=snapshot for a snapshot picture
3. Connect to the camera at rtsp://192.168.10.237:8554/video3_unicast with VLC for the rtsp stream
Default username and password for the streams is yacam/yacam

## Settings

1. Connecting to the http port of the camera provides some settings 
2. Eddit the yacam.conf file via ssh (default user root password root) for more options which are currently not supported on the web interf>
3. Change the default password via ssh. It will be saved and will survive firmware upgrades
4. Change username and password or disable authentication in the yacam.conf file for the streams

### Writing Config Files

TBD

### Resetting the configuration

Set to default values via ssh:
1. ssh into the camera
2. delete the /config/overlay/etc/yacam.conf config file
3. reboot

Add new yacam.conf file:
1. Copy the default yacam.conf file to and SD card
2. Insert the SD card to the camera and reboot it
3. After reboot, remove the SD card and reboot it again

Set the CLEAR_CONFIG_PARTITION to 1 in the yacam config file on the SD card. This will erase all files on the JFFS2 partition, including the root password if changed!:
1. Copy the default yacam.conf file to the SD card on your computer
2. Add CLEAR_CONFIG_PARTITION=1 to the end
3. Insert the SD card to the camera and reboot
4. After the camera is rebooted, remove the SD card edit the yacam.conf file to remove the CLEAR_CONFIG_PARTITION=1 command
5. Insert the SD card and reboot
6. Remove the SD card and reboot the camera one more time

## Troubleshooting

TBD

## Issues and support

Please open github issues

## Contributing

Pull requests are welcome. For fixes of code and documentation, please go ahead and submit a pull request.
