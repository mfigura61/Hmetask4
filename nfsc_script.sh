#!/bin/sh
sudo yum update -y
sudo yum install -y nfs-utils nfs-utils-lib
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable nfs-lock
sudo systemctl enable nfs-idmap
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start nfs-lock
sudo systemctl start nfs-idmap
sudo mkdir /media/nfs_share
sudo mount -t nfs 192.168.50.10:/nfs-share/ /media/nfs_share/  -o rw,noatime,noauto,x-systemd.automount,noexec,nosuid,proto=udp,vers=3
echo '192.168.50.10:/nfs-share/ /media/nfs_share/ nfs rw,sync,hard,intr,noatime,noauto,x-systemd.automount,noexec,proto=udp,vers=3 0 0' >> /etc/fstab
sudo systemctl restart remote-fs.target
 
