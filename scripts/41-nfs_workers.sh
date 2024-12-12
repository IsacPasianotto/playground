#!/bin/bash

mkdir -p /home/vagrant/shared

mount -t nfs kube-00:/export/home/vagrant/shared /home/vagrant/shared
echo 'kube-00:/export/home/vagrant/shared /home/vagrant/shared nfs defaults 0 0' | sudo tee -a /etc/fstab

systemctl enable --now nfs-client.target

