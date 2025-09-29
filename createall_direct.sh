set -xe
sudo ./install_direct.sh
sudo ./autoinstall_direct.sh
sudo chmod 400 ./liox_direct_base.qcow2
sudo chown joris:users ./liox_direct_base.qcow2
qemu-img create -f qcow2 -F qcow2 -b ./liox_direct_base.qcow2 ./liox_direct.qcow2
./startliox.sh
