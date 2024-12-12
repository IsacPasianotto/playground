#!/bin/bash

export ipmaster=192.168.132.60
export MUNGEUSER=1001

groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge -s /sbin/nologin munge
mkdir  -p /etc/munge /var/log/munge /var/run/munge

sudo systemctl enable munge

# Retrieve the key from the master node
scp -o StrictHostKeyChecking=no root@$ipmaster:/home/vagrant/munge.key /home/vagrant/munge.key
mv /home/vagrant/munge.key /etc/munge/munge.key

# Fix permissions and ownership
chown munge:munge /etc/munge/munge.key
chown -R munge:munge /var/lib/munge
chown munge:munge /var/log/munge
chown munge:munge /etc/munge
chown munge:munge /var/log/munge/munged.log
chmod 400 /etc/munge/munge.key
chmod 700 /etc/munge

systemctl start munge
