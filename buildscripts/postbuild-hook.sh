#!/bin/bash
set -e

echo "Peforming post rootfs build hooks"

# The path to the images output directory is passed as the first argument
DEFAULT_IMAGE_DIR="/yacam/build/buildroot-2016.02/output/images"
IMAGES=${1:-$DEFAULT_IMAGE_DIR}
BASE_DIR=${BASE_DIR:-/yacam/build/buildroot-2016.02/output}

# The environment variables BR2_CONFIG, HOST_DIR, STAGING_DIR,
# TARGET_DIR, BUILD_DIR, BINARIES_DIR and BASE_DIR are defined

# Put the kernel image on the tftp server
if [[ -d /var/lib/tftpboot ]]; then
	cp $IMAGES/uImage.lzma /var/lib/tftpboot
fi

RELEASE_DIR=/src/release
mkdir -p $RELEASE_DIR


cd /src
REVISION_HASH=`git rev-parse --quiet --short HEAD`
NOW=`date +'%Y-%m-%d_%H_%M_%S'`

# Copy the kernel image and bootloader to releases
cp $IMAGES/uImage.lzma $RELEASE_DIR
#cp $IMAGES/u-boot-lzo-with-spl.bin $RELEASE_DIR


MKIMAGE=/yacam/build/buildroot-2016.02/output/build/uboot-openmiko/tools/mkimage
if [ ! -f "/usr/sbin/mkimage" ]; then
	ln -s $MKIMAGE /usr/sbin/mkimage
fi

# Pack up the image so it can be installed using the factory demo.bin
# method. Use the default firmware for some pieces.
#
# Maximum sizes
#                                                                                                                                                                      
# "kernel" - 0x200000 or 2,097,152 bytes
# "rootfs" - 0x350000 or 3,473,408 bytes
# "driver" - 0xa0000 or 655,360 bytes
# "appfs" - 0x4a0000 or 4,849,664 bytes
#
# The total size the rootfs+driver+appfs is 8978432. However the /dev/mtdblock2 partition is 13828096.

KERNEL="$IMAGES/uImage.lzma"
PADDED_KERNEL="$IMAGES/uImagePadded.lzma"

SQUASHFSROOTIMG="$IMAGES/rootfs.squashfs"


KERNEL_MAXSIZE=$((16#200000))
ROOTFS_MAXSIZE=$(( $((16#350000)) + $((16#a0000)) + $((16#4a0000)) ))
FLASH_MAXSIZE=$(( $KERNEL_MAXSIZE + $ROOTFS_MAXSIZE ))

# Checks

KERNEL_BYTES=$(wc -c < "$KERNEL")
if [ $KERNEL_BYTES -ge $KERNEL_MAXSIZE ]; then
	echo "Error: Kernel image must be less than $KERNEL_MAXSIZE. It is $KERNEL_BYTES."
	exit 1
fi

# Pad the kernel to max size
cp $KERNEL $PADDED_KERNEL
truncate -s $KERNEL_MAXSIZE $PADDED_KERNEL

ROOTFS_BYTES=$(wc -c < "$SQUASHFSROOTIMG")
if [ $ROOTFS_BYTES -gt $ROOTFS_MAXSIZE ]; then
	echo "Error: rootfs image must be less than $ROOTFS_MAXSIZE. It is $ROOTFS_BYTES."
	exit 1
fi

# Combine kernel and rootfs into one file and pad it to total size of flash
KERNEL_AND_ROOTSQUASHFS="$IMAGES/kernel_and_root.squashfs.bin"
cat $PADDED_KERNEL $SQUASHFSROOTIMG > $KERNEL_AND_ROOTSQUASHFS

echo "Maximum size of flash image: $FLASH_MAXSIZE"
truncate -s $FLASH_MAXSIZE $KERNEL_AND_ROOTSQUASHFS


# Make an image for flashing
OUTFILE2="${RELEASE_DIR}/yacam_firmware.squashfs.bin"
$MKIMAGE -A MIPS -O linux -T firmware -C none -a 0 -e 0 -n jz_fw -d $KERNEL_AND_ROOTSQUASHFS $OUTFILE2


cp $OUTFILE2 $RELEASE_DIR/demo.bin
cp $OUTFILE2 $RELEASE_DIR/demo.yacam.$NOW.bin
echo "Firmware created: $RELEASE_DIR/demo.bin"

FINAL=$NET$SET64

echo "Create Firmware type indicator file"
case $FINAL in
	'ES0')
		echo "PAN128" > $IMAGES/otatype.txt
		;;
	'FS0')
		echo "WYZ128" > $IMAGES/otatype.txt
		;;
	'FS1')
		echo "XIAO64" > $IMAGES/otatype.txt
		;;
	*)
		echo "Illegal"
		;;
esac

echo "Creating OTA file"
tar -cvf $RELEASE_DIR/demo_ota.tar -C $IMAGES uImage.lzma rootfs.squashfs otatype.txt

case $FINAL in
	'ES0')
	        cp $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.pan.$NOW.tar
	        mv $RELEASE_DIR/demo.bin $RELEASE_DIR/demo.pan.bin
	        mv $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.pan.tar 
	        mv $RELEASE_DIR/demo.yacam.$NOW.bin $RELEASE_DIR/demo.yacam.pan.$NOW.bin
	        echo "Wyze PAN Firmware ready"
		;;
        'FS0')
                cp $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.128.$NOW.tar
                mv $RELEASE_DIR/demo.bin $RELEASE_DIR/demo.128.bin
                mv $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.128.tar 
                mv $RELEASE_DIR/demo.yacam.$NOW.bin $RELEASE_DIR/demo.yacam.128.$NOW.bin
                echo "Wyze V2 Firmware ready"
		;;
        'FS1')
                cp $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.64.$NOW.tar
                mv $RELEASE_DIR/demo.bin $RELEASE_DIR/demo.64.bin
                mv $RELEASE_DIR/demo_ota.tar $RELEASE_DIR/demo_ota.64.tar 
                mv $RELEASE_DIR/demo.yacam.$NOW.bin $RELEASE_DIR/demo.yacam.64.$NOW.bin
                echo "XIAO 64M Firmware ready"
		;;
	*)
		echo "Illegal"
		;;
esac

echo "FINAL="$FINAL

cat << EOF

Build and release complete.

Kernel       ==> $KERNEL ($KERNEL_BYTES / $KERNEL_MAXSIZE )
RootFS Image ==> $SQUASHFSROOTIMG ($ROOTFS_BYTES / $ROOTFS_MAXSIZE )

EOF
