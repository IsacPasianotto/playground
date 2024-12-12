#!/bin/bash

# Start kubeadm service

kubeadm init --pod-network-cidr=10.17.0.0/16 --service-cidr=10.96.0.0/12 > /root/kubeinit.log

# Retrieve the token to join the master for worker nodes
cat /root/kubeinit.log | grep -A 1 "kubeadm join" > /root/kubejoin_command.sh
chmod +777 /root/kubejoin_command.sh    # needed open permission for moving with scp

##
## kubectl configuration
##

# Root user
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
alias k=kubectl

# Vagrant User
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config

# to be reachable to other nodes

sudo cp /etc/kubernetes/admin.conf /home/vagrant/admin.conf
sudo chmod 666 /home/vagrant/admin.conf
