#!/usr/bin/env bash
set -x
sudo umount -l mnt/proc
sudo umount -l mnt/sys
sudo umount -l mnt/dev
sudo umount mnt/var/cache/apt/archives
sudo umount mnt/tmp

# sudo umount -l mnt/run

! mount | grep mnt
