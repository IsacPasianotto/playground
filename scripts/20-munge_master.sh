#!/bin/bash

export MUNGEUSER=1001

# groupadd -g $MUNGEUSER munge
# useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge -s /sbin/nologin munge

mkdir  -p /etc/munge /var/log/munge /var/run/munge

sudo systemctl enable munge

# Generate the munge key
sudo -u munge /usr/sbin/mungekey --verbose

# Fix permissions and ownership
chown -R munge:munge /var/lib/munge
chown munge:munge /var/log/munge
chown munge:munge /etc/munge
chown munge:munge /var/log/munge/munged.log
chmod 400 /etc/munge/munge.key
chmod 700 /etc/munge

# Allows nodes to retrieve the key

cp /etc/munge/munge.key /home/vagrant/munge.key
chown vagrant:vagrant /home/vagrant/munge.key
chmod 666 /home/vagrant/munge.key

systemctl start munge

