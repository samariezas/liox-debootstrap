#!/usr/bin/env bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <image.qcow2>"
    exit 1
fi

qemu-system-x86_64 \
    -m 2G -smp 2 -accel kvm \
    -cdrom ./alpine-extended-3.22.1-x86_64.iso \
    -fsdev local,path=./qemushared,security_model=passthrough,id=fsdev0 -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=rootfs \
    -drive file=$1,format=qcow2 \
    -boot d \
    -serial stdio \
    -net none \
    -display none

