#!/bin/bash

sudo su

dnf install -y openmpi openmpi-devel

# Enable the modules

echo "source /etc/profile.d/modules.sh" >> /etc/bashrc
echo "source /etc/profile.d/modules.sh" >> /root/.bashrc
echo "source /etc/profile.d/modules.sh" >> /home/vagrant/.bashrc

echo "module load mpi/openmpi-x86_64" >> /etc/bashrc
echo "module load mpi/openmpi-x86_64" >> /root/.bashrc
echo "module load mpi/openmpi-x86_64" >> /home/vagrant/.bashrc

# Most likely you will need the a compiler as well

dnf install -y gcc gcc-c++ gcc-gfortran

