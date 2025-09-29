#!/usr/bin/env bash
set -xe
qemu-img create -f qcow2 liox_direct_base.qcow2 16G
qemu-nbd -c /dev/nbd0 liox_direct_base.qcow2
parted -s /dev/nbd0 mklabel gpt mkpart ESP fat32 1MiB 513MiB set 1 boot on set 1 esp on mkpart primary ext4 513MiB 100%
mkfs.fat -F32 /dev/nbd0p1
mkfs.ext4 /dev/nbd0p2
mount /dev/nbd0p2 ./mnt_direct
cp -rp ./mnt/* ./mnt_direct/
EFI_UUID=$(blkid -s UUID -o value /dev/nbd0p1)
ROOT_UUID=$(blkid -s UUID -o value /dev/nbd0p2)
cat << EOF > ./mnt_direct/etc/fstab
UUID=${EFI_UUID}    /boot/efi   vfat umask=0077                     0   1
UUID=${ROOT_UUID}   /           ext4 defaults,errors=remount-ro     0   1
EOF
mkdir -p ./mnt_direct/boot/efi
umount -R ./mnt_direct/
qemu-nbd -d /dev/nbd0
