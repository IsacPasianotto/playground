#!/bin/bash
dnf install -y slurm-slurmctld
systemctl enable slurmctld
systemctl start slurmctld
systemctl enable slurmd
systemctl start slurmd


# Fix permissions and ownership
mkdir -p /run/slurm
chmod 0755 /run/slurm
chown -R slurm:slurm /run/slurm
mkdir -p /var/spool/slurm
chown -R slurm:slurm /var/spool/slurm
chown -R slurm:slurm /var/log/slurm

mkdir -p /var/lib/slurm/slurmd
sudo chown -R slurm:slurm /var/lib/slurm/slurmd/
