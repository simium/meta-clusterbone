#! /bin/sh
# populatecard.sh
# Based on mkcard.sh v0.5
# (c) Copyright 2009 Graeme Gregory <dp@xora.org.uk>
# Licensed under terms of GPLv2
#
# Parts of the procudure base on the work of Denys Dmytriyenko
# http://wiki.omap.com/index.php/MMC_Boot_Format

export LC_ALL=C

if [ $# -ne 1 ]; then
	echo "Usage: $0 <drive>"
	exit 1;
fi

DRIVE=$1
IMAGE_PATH="../../build/tmp/deploy/images/beaglebone"
PATH_TO_SDBOOT="boot"
PATH_TO_SDROOT="root"
IMAGE_NAME="console-image-beaglebone.tar.bz2"

# handle various device names.
# note something like fdisk -l /dev/loop0 | egrep -E '^/dev' | cut -d' ' -f1 
# won't work due to https://bugzilla.redhat.com/show_bug.cgi?id=649572

PARTITION1=${DRIVE}1
if [ ! -b ${PARTITION1} ]; then
	PARTITION1=${DRIVE}p1
fi

PARTITION2=${DRIVE}2
if [ ! -b ${PARTITION2} ]; then
	PARTITION2=${DRIVE}p2
fi

echo "Creating temp dirs boot and root..."
mkdir ${PATH_TO_SDBOOT}
mkdir ${PATH_TO_SDROOT}

echo "Mounting the SD card partitions..."
mount -t vfat ${PARTITION1} ${PATH_TO_SDBOOT}
mount -t ext2 ${PARTITION2} ${PATH_TO_SDROOT}

echo "Copying files to SD card..."
cp ${IMAGE_PATH}/MLO ${PATH_TO_SDBOOT}/
cp ${IMAGE_PATH}/u-boot.img ${PATH_TO_SDBOOT}/
cp ${IMAGE_PATH}/zImage ${PATH_TO_SDBOOT}/
tar xf ${IMAGE_PATH}/${IMAGE_NAME} -C ${PATH_TO_SDROOT}

echo "Syncing disks..."
sync

echo "Unmounting the SD card partitions..."
umount ${PATH_TO_SDBOOT}
umount ${PATH_TO_SDROOT}

echo "Syncing disks..."
sync

echo "Removing temp dirs..."
rm -rf ${PATH_TO_SDBOOT}
rm -rf ${PATH_TO_SDROOT}

echo "Done!"


