#!/bin/bash

echo "Preparing SSH keys..."
cp /data/id_rsa /root/.ssh/id_rsa
cp /data/id_rsa.pub /root/.ssh/id_rsa.pub
cp /data/ssh_config /root/.ssh/config
cp /data/gitconfig /root/.config
chown -R root:root /root/.ssh
chmod 0400 /root/.ssh/id_rsa
chmod 0400 /root/.ssh/config

echo "Using repository from '$REPO_URL'"
cd /wiki
if [ -d /wiki/.git ]; then
    echo "Updating..."
    /root/update.sh
else
    echo "Cloning..."
    git clone $REPO_URL .
fi

echo "Preparing repo push & pull cronjob..."
crontab /root/crontab
crontab -l
/etc/init.d/cron start

echo "Virtual-hosts: $VIRTUAL_HOST"

echo "Starting gollum application with rackup..."
rackup -E deployment
