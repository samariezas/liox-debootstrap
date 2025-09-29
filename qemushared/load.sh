#!/usr/bin/env bash
mkdir -p /mnt/disk
set -xe
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart ESP fat32 1MiB 513MiB
parted -s /dev/sda set 1 boot on
parted -s /dev/sda set 1 esp on
parted -s /dev/sda mkpart primary ext4 513MiB 100%

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt/disk
tar --numeric-owner -xpvf /mnt/rootfs/rootfs.tar.zstd -C /mnt/disk
mount /dev/sda1 /mnt/disk/boot/efi
genfstab -U /mnt/disk | tee /mnt/disk/etc/fstab

arch-chroot /mnt/disk /bin/bash -c 'export PATH=$PATH:/sbin && grub-install --target=x86_64-efi --removable /dev/sda && update-grub'
