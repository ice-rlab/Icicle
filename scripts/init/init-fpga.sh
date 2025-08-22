#!/usr/bin/env bash
PC_DIR=$(git rev-parse --show-toplevel)
FS_DRIVER_DIR=$PC_DIR/sims/firesim-drivers
XVSEC_DIR=$FS_DRIVER_DIR/dma_ip_drivers_xvsec
DMA_DIR=$FS_DRIVER_DIR/dma_ip_drivers


# Build and install dma drivers
cd $DMA_DIR/XDMA/linux-kernel/xdma
sudo make install
sudo insmod $(find /lib/modules/$(uname -r) -name "xdma.ko") poll_mode=1
lsmod | grep -i xdma


# Build and install xvsec drivers
cd $XVSEC_DIR/XVSEC/linux-kernel/
make clean all
sudo make install
sudo modprobe xvsec
lsmod | grep -i xvsec
which xvsecctl


# Display FPGA output to check if worked
lspci -vvv -d 10ee:903f
ls -la /sys/bus/pci/devices/0000:01:00.0/


# Change XDMA device permissions
sudo chmod  ugo++rwx /dev/xdma*

