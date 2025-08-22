#!/bin/bash -x

#####################################################
### RUN THIS FROM YOUR DESIRED DOWNLOAD DIRECTORY ###
#####################################################

# Find directory of setup.sh
SETUP_DIR=`dirname $0`

# Find download directory
DOWNLOAD_DIR=`pwd`

echo "SETUP_DIR is $SETUP_DIR"
echo "DOWNLOAD_DIR is $DOWNLOAD_DIR"

pushd $DOWNLOAD_DIR

# Download prebuilt oss-cad-suite with Yosys synthesis tool and OpenROAD place and route tool
lsb_release -r # ideally 22.04 or 20.04 since Precision provides prebuilt package
wget https://github.com/Precision-Innovations/OpenROAD/releases/download/2024-12-14/openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb
sudo dpkg -i $DOWNLOAD_DIR/openroad_2.0-17598-ga008522d8_amd64-ubuntu-22.04.deb
sudo apt-get install -f
wget https://www.klayout.org/downloads/Ubuntu-22/klayout_0.29.11-1_amd64.deb
sudo dpkg -i $DOWNLOAD_DIR/klayout_0.29.11-1_amd64.deb
sudo apt-get install -f
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-01-21/oss-cad-suite-linux-x64-20250121.tgz
tar xzvf oss-cad-suite-linux-x64-20250121.tgz

# sv2v
wget https://github.com/zachjs/sv2v/releases/download/v0.0.12/sv2v-Linux.zip
unzip sv2v-Linux.zip -d .

# Clone scripts repository
git clone https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git

popd # $DOWNLOAD_DIR

# Copy source script
cp ${SETUP_DIR}/bash/source_vlsi.sh ${DOWNLOAD_DIR}/source.sh
sed -I -e "s+__DOWNLOAD_DIR__+${DOWNLOAD_DIR}+g" ${DOWNLOAD_DIR}/source.sh
rm -f ${DOWNLOAD_DIR}/source.sh-e
