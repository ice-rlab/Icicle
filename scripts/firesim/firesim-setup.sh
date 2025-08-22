#!/usr/bin/env bash
local ORIGINAL_DIR=$(pwd)
# Setup ssh config for firesim runs
cd ~/.ssh
ssh-agent -s > AGENT_VARS
source AGENT_VARS
ssh-add firesim.pem

# Insert xdma kernel module
sudo rmmod xdma.ko
sudo insmod $(find /lib/modules/$(uname -r) -name "xdma.ko") poll_mode=1
lsmod | grep -i xdma

# Insert xvsec module
sudo rmmod xvsec
sudo modprobe xvsec
lsmod | grep -i xvsec

# Make sure we have correct permissions to read and write to /dev/xdma
# Unnecessarily permissive, but works for now
sudo chmod  ugo++rw /dev/xdma*

# Setup environment
cd $FS_DIR
source sourceme-manager.sh --skip-ssh-setup

cd $ORIGINAL_DIR