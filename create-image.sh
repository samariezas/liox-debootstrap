#!/usr/bin/env bash
set -xeu

if [ $(id -u) -ne 0 ]
then
	echo "Script must be run as root"
	exit 1
fi

source config.sh

if [ -d $BUILD_DIR ]
then
	echo "Directory \`$BUILD_DIR\` exists"
	exit 1
fi

mkdir -p $CACHE_DIR
mkdir -p $CHROOT_CACHE_DIR

if [ -f $BUILD_IMAGE ]
then
	read -p "Image \`$BUILD_IMAGE\` already exists. Rebuild? [y/N] " prompt
	if [[ $prompt != "y" && $prompt != "Y" ]]
	then
		echo "Aborting..."
		exit 2
	fi
fi

mkdir $BUILD_DIR
debootstrap --cache-dir=$(realpath $CACHE_DIR) --arch $ARCH stable $BUILD_DIR https://deb.debian.org/debian

mkdir -p $BUILD_DIR/boot/efi
mkdir -p $BUILD_DIR/var/cache/apt/archives
mount --make-rslave --rbind /proc $BUILD_DIR/proc
mount --make-rslave --rbind /sys $BUILD_DIR/sys
mount --make-rslave --rbind /dev $BUILD_DIR/dev
# mount --make-rslave --rbind /run $BUILD_DIR/run
mount --bind $CHROOT_CACHE_DIR $BUILD_DIR/var/cache/apt/archives
mount -t tmpfs chroot_tmp $BUILD_DIR/tmp
cp ./chroot-script.sh ./config.sh $BUILD_DIR
cp -r ./includes.chroot $BUILD_DIR
cat << EOF > $BUILD_DIR/etc/apt/apt.conf.d/99cache
Binary::apt::APT::Keep-Downloaded-Packages "true";
APT::Keep-Downloaded-Packages "true";
EOF
chroot $BUILD_DIR /bin/bash -c \
	"/bin/env -i /bin/bash /chroot-script.sh"
