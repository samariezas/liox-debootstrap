#!/usr/bin/env bash
set -xe
qemu-img create -f qcow2 liox.qcow2 16G
./create-image.sh
./unmount.sh
sudo tar --zstd --numeric-owner -cpf ./qemushared/rootfs.tar.zstd -C mnt .
./autoinstall.sh
