#!/bin/bash

# Login as root, as some of the commands require root access
# sudo su

export ipmaster=192.168.132.60

#
# Retrieve kubeconfig from master
#

scp -o StrictHostKeyChecking=no root@$ipmaster:/home/vagrant/admin.conf /home/vagrant/admin.conf

# Root user
mkdir -p /root/.kube
cp -i /home/vagrant/admin.conf /root/.kube/config
chown $(id -u):$(id -g) /root/.kube/config

# Vagrant user
mkdir -p /home/vagrant/.kube
mv /home/vagrant/admin.conf /home/vagrant.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

#
# Retrieve kubejoin command from master
#

scp -o StrictHostKeyChecking=no root@$ipmaster:/root/kubejoin_command.sh /root/kubejoin_command.sh
/root/kubejoin_command.sh
