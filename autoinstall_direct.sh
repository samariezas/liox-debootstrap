#!/usr/bin/env -S expect -f
spawn ./startalpine.sh ./liox_direct_base.qcow2
expect "localhost login:"
send "root\r"
expect "localhost:~#"
send "mkdir /mnt/rootfs && mkdir /mnt/disk && mount -t 9p -o trans=virtio,version=9p2000.L rootfs /mnt/rootfs\r"
expect "localhost:~#"
send "/mnt/rootfs/loaddirect.sh\r"
interact
