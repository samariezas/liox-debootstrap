#!/usr/bin/env bash
set -xeu

source config.sh

LANG=C.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOME=/root
SHELL=/bin/bash
TERM=xterm
DEBIAN_FRONTEND=noninteractive

apt -y install lsb-release
CODENAME=$(lsb_release --codename --short)
cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ $CODENAME main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ $CODENAME main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security $CODENAME-security main contrib non-free non-free-firmware
deb-src https://security.debian.org/debian-security $CODENAME-security main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ $CODENAME-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ $CODENAME-updates main contrib non-free non-free-firmware
EOF

apt -y update

rm /etc/localtime
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

apt -y install locales
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "lt_LT.UTF-8 UTF-8" >> /etc/locale.gen
echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale
locale-gen

echo $HOSTNAME > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1 localhost
127.0.1.1 $HOSTNAME

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

apt -y install linux-image-amd64 firmware-linux grub-efi debconf-utils wget gpg

mkdir -p /etc/apt/trusted.gpg.d/
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/ms-vscode-keyring.gpg
apt -y update

echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
echo "keyboard-configuration keyboard-configuration/variant select English (US)" | debconf-set-selections
echo "localepurge localepurge/nopurge multiselect en, en_US, en_US.UTF-8, lt, lt_LT, lt_LT.UTF-8, pl, pl_PL, pl_PL.UTF-8, ru, ru_RU, ru_RU.UTF-8" | debconf-set-selections
echo "localepurge localepurge/use-dpkg-feature boolean false" | debconf-set-selections

apt -y install \
    task-laptop \
    plasma-desktop kwin-x11 sddm sddm-theme-breeze xserver-xorg \
    dolphin konsole kwrite ark gwenview okular \
    firefox-esr wget \
    xserver-xorg-video-all \
    vim-gtk3 joe gedit scite geany geany-plugins codeblocks codeblocks-contrib \
    kate \
    zsh mc emacs nano git \
    make gcc g++ gdb ddd valgrind \
    python3 \
    strace lsof tree curl dnsutils screen \
    iotop tmux htop kpartx tsocks units locate \
    bridge-utils bash-completion rfkill apt-file ntpsec locales \
    iptables-persistent \
    localepurge \
    gdb-doc manpages \
    python3-requests \
    kcalc apt-transport-https \
    clang firmware-iwlwifi kdevelop \
    libreoffice-calc libreoffice-impress libreoffice-kf6 libreoffice-plasma libreoffice-writer \
    neovim ruby vim whois \
    sublime-text code

cp -rf /includes.chroot/* /

for P in $(ls /usr/share/liox-config/patches/*.patch); do
    patch -d/ -p0 < ${P}
done
echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub

# useradd -m -s /bin/bash -p ${D0_PWD_HASH} d0
# useradd -m -s /bin/bash -p ${D1_PWD_HASH} d1
# useradd -m -s /bin/bash -p ${D2_PWD_HASH} d2
LIOADMIN_PWD_HASH=$(echo "test" | mkpasswd -s -m sha-512)
useradd -m -s /bin/bash -p ${LIOADMIN_PWD_HASH} lioadmin
usermod -a -G sudo lioadmin

rm -rf /includes.chroot /etc/apt/apt.conf.d/99cache /chroot-script.sh /config.sh
