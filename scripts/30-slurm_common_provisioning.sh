#!/bin/bash

export SLURMUSER=1002
groupadd -g $SLURMUSER slurm
useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm -s /bin/bash slurm

##
## Remove default config and put a proper one
##
rm -f /etc/slurm/slurm.conf

cat << EOF | sudo tee /etc/slurm/slurm.conf
ClusterName=slurmcluster
SlurmctldHost=kube-00
ProctrackType=proctrack/linuxproc

ReturnToService=2

SlurmctldPidFile=/run/slurmctld.pid

SlurmdPidFile=/run/slurmd.pid

SlurmdSpoolDir=/var/lib/slurm/slurmd

StateSaveLocation=/var/lib/slurm/slurmctld

SlurmUser=slurm

TaskPlugin=task/none

SchedulerType=sched/backfill

SelectType=select/cons_tres

SelectTypeParameters=CR_Core_Memory

AccountingStorageType=accounting_storage/none

JobCompType=jobcomp/none

JobAcctGatherType=jobacct_gather/none

SlurmctldDebug=info

SlurmctldLogFile=/var/log/slurm/slurmctld.log

SlurmdDebug=info

SlurmdLogFile=/var/log/slurm/slurmd.log

NodeName=kube-00 NodeAddr=192.168.132.60 CPUs=2 RealMemory=1953
NodeName=kube-01 NodeAddr=192.168.132.61 CPUs=2 RealMemory=1953
NodeName=kube-02 NodeAddr=192.168.132.62 CPUs=2 RealMemory=1953

# PartitionName ################################################################
#
# Name by which the partition may be referenced (e.g. "Interactive").  This
# name can be specified by users when submitting jobs. If the PartitionName is
# "DEFAULT", the values specified with that record will apply to subsequent
# partition specifications unless explicitly set to other values in that
# partition record or replaced with a different set of default values. Each
# line where PartitionName is "DEFAULT" will replace or add to previous default
# values and not a reinitialize the default values.

PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP
PartitionName=prod Nodes=kube-01,kube-02 Default=NO MaxTime=INFINITE State=UP
EOF

dnf install -y slurm-slurmctld
systemctl enable slurmctld
systemctl start slurmctld
systemctl enable slurmd
systemctl start slurmd



###### Set the right permission also there:
mkdir -p /run/slurm
chmod 0755 /run/slurm
chown -R slurm:slurm /run/slurm
mkdir -p /var/spool/slurm
chown -R slurm:slurm /var/spool/slurm
chown -R slurm:slurm /var/log/slurm

mkdir -p /var/lib/slurm/slurmd
sudo chown -R slurm:slurm /var/lib/slurm/slurmd/
