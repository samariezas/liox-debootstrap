#!/usr/bin/env bash
set -xeu

source ./config.sh
umount -l mnt/proc
umount -l mnt/sys
umount -l mnt/dev
umount mnt/var/cache/apt/archives
umount mnt/tmp

! mount | grep mnt
