#!/bin/bash

systemctl enable --now nfs-server.service

# Create a nfs shared folder in /home/vagrant/shared
mkdir -p /home/vagrant
mkdir -p /home/vagrant/shared
chown nobody:nobody /home/vagrant/shared
chmod 777 /home/vagrant/shared
mkdir -p /export/home
mkdir -p /export/home/vagrant
mkdir -p /export/home/vagrant/shared
sudo chown nobody:nobody /export/home/vagrant
sudo chmod 777 /export/home/vagrant/shared

echo '/export/home/vagrant/shared *(rw,sync,no_subtree_check,no_root_squash)' | sudo tee -a /etc/exports
echo "kube-00:/export/home/vagrant/shared /home/vagrant/shared nfs defaults 0 0" | sudo tee -a /etc/fstab

exportfs -a
mount -t nfs kube-00:/export/home/vagrant/shared /home/vagrant/shared

systemctl enable --now nfs-client.target
