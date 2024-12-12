#! /bin/bash

##
## Network config
##

if [[ $(nmcli -t c show  | grep "Wired connection 2" | wc -l) -ne 0 ]]; then
nmcli c del "Wired connection 2";
fi

if [[ $(nmcli -t c show  | grep kube | wc -l) -ne 0 ]]; then
nmcli c del "kube-net";
fi

nmcli con add type ethernet \
    con-name kube-net \
    ifname eth1 \
    ip4 $1/24 \
    gw4 192.168.132.1 \
    ipv4.method manual \
    autoconnect yes;

nmcli con up kube-net;

##
## Use the keys in ../ssh to access the VMs
##

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxToLxTa5zzD6EboxuHsuLcnJ5XK5gUjthGbYRayO7k3GCF0m2IxMP3X3ji00+QY0I7SNmg20uv1Yf6Pz0qHHe8XPhT2A4t0i/ERgSqncwmd272R26UGcITxoWFc3dM6daFJrso/VbHDhAsjr1zJm51s0/aE8SImWuzNwdD5vM37J8oayLgNrd3HslIgFuEVp+4L2/wEbl9QwP94GIGpQ6wSgN33eHuX4oFj7brAnACaprQVJ20DbPpzlRhEUHc8gqSFqx4PERAQoSddfbhuZNv1wNB7+J50jybPbLRqFl2BN763i90xLahncZrb867ETPG7n8OZHqAleIAdw3iH1cy0gtkKU/fLTakFn7rxTIYwMDMG8soPL1N7B+PFC+1pMKCesBFWJpLQtiYXOmYQFETBYV0puOUrB7m2M9nb9LJFTlHxTj7sPFxuyDOqf8HuT5Wwf1dxEzjuvw/P/+zUFnQshd/NlczBzork2qaUwf14qchmM/ZX0EsOU5U6+D2e8= hpc-devel" >> /root/.ssh/authorized_keys

echo "-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
" > /root/.ssh/id_rsa;

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxToLxTa5zzD6EboxuHsuLcnJ5XK5gUjthGbYRayO7k3GCF0m2IxMP3X3ji00+QY0I7SNmg20uv1Yf6Pz0qHHe8XPhT2A4t0i/ERgSqncwmd272R26UGcITxoWFc3dM6daFJrso/VbHDhAsjr1zJm51s0/aE8SImWuzNwdD5vM37J8oayLgNrd3HslIgFuEVp+4L2/wEbl9QwP94GIGpQ6wSgN33eHuX4oFj7brAnACaprQVJ20DbPpzlRhEUHc8gqSFqx4PERAQoSddfbhuZNv1wNB7+J50jybPbLRqFl2BN763i90xLahncZrb867ETPG7n8OZHqAleIAdw3iH1cy0gtkKU/fLTakFn7rxTIYwMDMG8soPL1N7B+PFC+1pMKCesBFWJpLQtiYXOmYQFETBYV0puOUrB7m2M9nb9LJFTlHxTj7sPFxuyDOqf8HuT5Wwf1dxEzjuvw/P/+zUFnQshd/NlczBzork2qaUwf14qchmM/ZX0EsOU5U6+D2e8=" > /root/.ssh/id_rsa.pub;

chmod 600 /root/.ssh/id_rsa;

mkdir -p /home/vagrant/.ssh

cp /root/.ssh/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
cp /root/.ssh/id_rsa /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa.pub
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa.pub

chmod 600 /root/.ssh/authorized_keys;

##
## Install some useful packets
##

# tools
sudo dnf install -y bat htop \
     tmux curl git util-linux-user \
     podman helm golang \
     nfs-utils libnfsidmap sssd-nfs-idmap \
     munge munge-libs munge-devel \
     slurm-slurmd slurm-pam_slurm \
     openmpi openmpi-devel \
     gcc gcc-c++ gcc-gfortran \
     wget vim

# Install k9s
cd /tmp
wget https://github.com/derailed/k9s/releases/download/v0.28.2/k9s_Linux_amd64.tar.gz
tar -xvf k9s_Linux_amd64.tar.gz
chmod +x k9s
sudo mv k9s /usr/local/bin

cat << EOF | tee -a /home/vagrant/.bashrc
EDITOR=vim
alias k=kubectl
source <(kubectl completion bash)
EOF

##
## Poor dns
##

echo "" >> /etc/hosts
echo "192.168.132.60 kube-00 kube-00" >> /etc/hosts
echo "192.168.132.61 kube-01 kube-01" >> /etc/hosts
echo "192.168.132.62 kube-02 kube-02" >> /etc/hosts

##
## Enable MPI and make modules auto-load
##

echo "source /etc/profile.d/modules.sh" >> /etc/bashrc
echo "source /etc/profile.d/modules.sh" >> /root/.bashrc
echo "source /etc/profile.d/modules.sh" >> /home/vagrant/.bashrc

echo "module load mpi/openmpi-x86_64" >> /etc/bashrc
echo "module load mpi/openmpi-x86_64" >> /root/.bashrc
echo "module load mpi/openmpi-x86_64" >> /home/vagrant/.bashrc
