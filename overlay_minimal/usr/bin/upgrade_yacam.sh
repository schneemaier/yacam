#!/bin/sh

OTAFILE=demo_ota.128.tar
OTATYPE=WYZ128

do_reboot() {
  sleep 5
  reboot
}

do_flash() {
  # $1 = path to file (/tmp/rootfs.jffs2)
  # $2 = MTD device number (0, 1, 2)
  if [[ ! -n $1 || ! -n $2 ]]; then
    echo "Invalid parameters given to do_flash."
    return 1
  fi

  FILE=$1
  DEVICE=/dev/mtd${2}
  BLOCKDEVICE=/dev/mtdblock${2}
  if [[ ! -s $FILE ]]; then
    echo "ERROR: File $FILE does not exist or is 0 bytes."
    return 1
  fi

  FILE_SIZE=$(wc -c < $FILE)
  echo "Flashing contents of $(basename $FILE) to $DEVICE..."
  flashcp -v $FILE $DEVICE
  if [[ $? -ne 0 ]]; then
    echo "ERROR: New flash contents on $DEVICE do not match the source file $FILE."
    return 1
  else
    echo "Verified the contents of $DEVICE match the source file $FILE."
  fi
}

if [[ $# -lt 2 ]] ; then
  echo './upgrade_yacam.sh <MODE> <PARAMS>'
  echo '  GIT <GIT_TAG>'
  echo '  SD <FILE ON SDCARD>'
  echo '  WWW <FILE ON TMP>'
  exit 1
fi
if [[ $# -lt 3 ]] ; then
  read -p "Are you sure you want to flash new firmware? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
    exit 1
  fi
else
  if [[ ! $3 =~ ^[Yy]$ ]] ; then
    exit 1
  fi
fi
echo -e "\nStopping services..."
# run the services stop script
/etc/init.d/S90scripts stop
/etc/init.d/S70autonight stop
/etc/init.d/S66mjpg_streamer stop
/etc/init.d/S64v4l2rtpserver stop
/etc/init.d/S62capture stop

echo "Services stopped."

cd /tmp

MODE=`echo $1 | tr [:lower:] [:upper:]`

case "$MODE" in
  GIT)
    echo -e "\nDownloading updated images from GitHub..."
    curl -fL https://github.com/schneemaier/yacam/releases/download/$GIT_TAG/$OTAFILE -o /tmp/demo_ota.tar
    if [[ $? -ne 0 ]]; then
      echo "Failed to download YaCAM $2 OTA from GitHub."
      exit 1
    fi
    tar -xvf /tmp/demo_ota.tar
    if [[ $? -ne 0 ]]; then
      echo "TAR error"
      exit 1
    fi
    echo "Image downloaded and extracted successfully."
    ;;
  SD)
    mount /dev/mmcblk0p1 /sdcard
    cp /sdcard/$2 /tmp/demo_ota.tar
    if [[ $? -ne 0 ]]; then
      echo "Failed to copy YaCAM $2 from SD card."
      exit 1
    fi
    tar -xvf /tmp/demo_ota.tar
    if [[ $? -ne 0 ]]; then
      echo "TAR error. Reboot in 5 seconds"
      do_reboot &
      exit 1
    fi
    echo "Image extracted successfully."
    ;;
  WWW)
    tar -xvf "$2"
    if [[ $? -ne 0 ]]; then
      echo "TAR error. Reboot in 5 seconds"
      do_reboot &
      exit 1
    fi
    echo "<p>Image extracted successfully.</p>"
    if [ `cat /tmp/otetype.txt` != "$OTATYPE" ]
    then
      echo "Incorrect OTA type. Reboot in 5 seconds"
      do_reboot &
      exit 1
    fi

    ;;
  *)
    echo "Not implemented"
    exit 1
    ;;
esac

# Doing a while loop here to use break in case of failure
while true; do
  echo -e "\nFlashing kernel image (uImage.lzma)"
  # Flash uImage.lzma to /dev/mtd1
  if do_flash /tmp/uImage.lzma 1; then
    true
  else
    break
  fi
  echo -e "\nFlashing root file system (rootfs)"
  # Flash rootfs.squashfs to /dev/mtd2
  if do_flash /tmp/rootfs.squashfs 2; then
    true
  else
    break
  fi
  # Mark that upgrade is completed to ensure config file update on reboot
  touch /etc/upgraded.fsh
  echo -e "\nYaCAM image flashed successfully. Reboot is required.\n"

  if [[ $# -lt 3 ]] ; then
    read -p "Do you want to reboot? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      do_reboot &
    fi
    exit 0
  else
    echo -e "\nUpgrade finished! Rebooting in 5 seconds...."
    do_reboot &
    exit 0
  fi
done

echo -e "\nERROR: Upgrade failed.  Your system may not survive a reboot!  Troubleshoot and retry the upgrade.\n"
exit 1
