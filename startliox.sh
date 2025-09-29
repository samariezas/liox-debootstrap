qemu-system-x86_64 \
    -bios $(nix-build '<nixpkgs>' -A OVMF.fd)/FV/OVMF.fd \
    -m 2G -smp 2 -accel kvm \
    -drive file=./liox.qcow2,format=qcow2
