#!/bin/bash

set -e

HOSTNAME="lioxbox"
TIMEZONE="Europe/Vilnius"
IMAGE_SIZE_MB="16G"
ARCH="amd64"
BUILD_DIR="./mnt"
DEBOOTSTRAP_CACHE_DIR="./.cache/debootstrap"
APT_CACHE_DIR="./.cache/apt"
BUILD_IMAGE="./liox.qcow2"
