#!/bin/bash
set -e

export SET64=$2
export NET=$3
echo "Executing pre filesystem image creation script"

# The environment variables BR2_CONFIG, HOST_DIR, STAGING_DIR,
# TARGET_DIR, BUILD_DIR, BINARIES_DIR and BASE_DIR are defined

DEFAULT_IMAGE_DIR="/yacam/build/buildroot-2016.02/output/images"
BASE_DIR=${BASE_DIR:-/yacam/build/buildroot-2016.02/output}
IMAGES="${BASE_DIR}/images"
HOST_DIR=${HOST_DIR:-/yacam/build/buildroot-2016.02/output/host}
TARGET_DIR=${TARGET_DIR:-/yacam/build/buildroot-2016.02/output/target}

#remove not needed modul. If the modul is disabled in the config, the other moduls are not built :(
rm -rf "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/net/wireless/rtl818x/rtl8188eu"

#remove not needed wpa_supplicant.conf
rm -rf "${TARGET_DIR}/etc/wpa_supplicant.conf"

#add missing sensor modul
#mkdir -p "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/media/platform/sensors/jxf23"
#cp /src/external_moduls/sensor_jxf23.ko "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/media/platform/sensors/jxf23/"

# remove /var/log symlink. Due to overlayfs bug it is not possible to modify it. It is recreated on boot in the overlayfs
rm -rf "${TARGET_DIR}/var/log"

cd /src
#GIT_REVISION=$(git rev-parse --quiet --short HEAD)
GIT_REVISION=$(git rev-parse --quiet --short HEAD)

echo $GIT_REVISION > $TARGET_DIR/etc/GITVERSION
date > $TARGET_DIR/etc/BUILDDATE
echo "Set64="$SET64" NET="$NET
if [ "$SET64" == "1" ]
then
	echo "64MB"
	sed -i "/MAIN_X_RES/c\MAIN_X_RES=1280" $TARGET_DIR/etc/yacam.conf.orig
	sed -i "/MAIN_Y_RES/c\MAIN_Y_RES=720" $TARGET_DIR/etc/yacam.conf.orig
	sed -i "/OTAFILE=/c\OTAFILE=demo_ota.64.tar" $TARGET_DIR/usr/bin/upgrade_yacam.sh
	sed -i "/OTATYPE=/c\OTATYPE=XIAO64" $TARGET_DIR/usr/bin/upgrade_yacam.sh
else
	echo "128MB"
	sed -i "/MAIN_X_RES/c\MAIN_X_RES=1920" $TARGET_DIR/etc/yacam.conf.orig
	sed -i "/MAIN_Y_RES/c\MAIN_Y_RES=1080" $TARGET_DIR/etc/yacam.conf.orig
	sed -i "/OTAFILE=/c\OTAFILE=demo_ota.128.tar" $TARGET_DIR/usr/bin/upgrade_yacam.sh
        sed -i "/OTATYPE=/c\OTATYPE=WYZ128" $TARGET_DIR/usr/bin/upgrade_yacam.sh
fi

if [ "$NET" == "FS" ]
then
	echo "FS"
	sed -i "/WIFI_MODULE/c\WIFI_MODULE=8189fs" $TARGET_DIR/etc/yacam.conf.orig
	rm -r "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/net/wireless/rtl818x/rtl8189ES"
	rm -r "${TARGET_DIR}/etc/init.d/S25motor"
	rm -r "${TARGET_DIR}/usr/bin/motor"
	rm -r "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/misc/motor"
else
	echo "ES"
	sed -i "/WIFI_MODULE/c\WIFI_MODULE=8189es" $TARGET_DIR/etc/yacam.conf.orig
	sed -i "/OTAFILE=/c\OTAFILE=demo_ota.pan.tar" $TARGET_DIR/usr/bin/upgrade_yacam.sh
	sed -i "/OTATYPE=/c\OTATYPE=PAN128" $TARGET_DIR/usr/bin/upgrade_yacam.sh
	rm -r "${TARGET_DIR}/lib/modules/3.10.14/kernel/drivers/net/wireless/rtl818x/rtl8189FS"
fi
