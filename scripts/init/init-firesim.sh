#!/usr/bin/env bash
export PC_DIR=$(git rev-parse --show-toplevel)

cd ~/
mkdir firesim-script-installs
cd firesim-script-installs
git clone https://github.com/firesim/firesim
cd firesim

sudo cp deploy/sudo-scripts/* /usr/local/bin
sudo cp platforms/xilinx_alveo_u250/scripts/* /usr/local/bin

rm -rf ~/firesim-script-installs    # or the temp. dir. created previously

sudo addgroup firesim;
sudo chmod 755 /usr/local/bin/firesim*
sudo chgrp firesim /usr/local/bin/firesim*

echo "%firesim ALL=(ALL) NOPASSWD: /usr/local/bin/firesim-*" | sudo tee /etc/sudoers.d/firesim > /dev/null
sudo chmod 400 /etc/sudoers.d/firesim

mkdir -p ~/.ssh
[ -f ~/.ssh/authorized_keys ] || touch ~/.ssh/authorized_keys
cd ~/.ssh
[ -f firesim.pem ] || ssh-keygen -t ed25519 -C "firesim.pem" -f firesim.pem -N ""
chmod 0600 authorized_keys

for pubkey in ~/.ssh/*.pub; do
    if [[ -f "$pubkey" ]]; then
        key_content=$(cat "$pubkey")
        if ! grep -qxF "$key_content" ~/.ssh/authorized_keys; then
            echo "Adding $pubkey to authorized_keys"
            echo "$key_content" >> ~/.ssh/authorized_keys
        else
            echo "$pubkey already present in authorized_keys"
        fi
    fi
done

cd ~/.ssh
ssh-agent -s > AGENT_VARS
source AGENT_VARS
ssh-add firesim.pem


BASHRC_FILE="$HOME/.bashrc"
if [ -f "$BASHRC_FILE" ]; then
    # Comment out the specified lines if they exist
    sed -i '/^case \$- in/,/^esac/s/^/#/' "$BASHRC_FILE"
    echo "Lines commented out in $BASHRC_FILE."
else
    echo "$BASHRC_FILE does not exist!"
fi

ssh -o StrictHostKeyChecking=no localhost printenv


# Apply firesim patches

cd $PC_DIR/platforms/chipyard/sims/firesim/platforms/xilinx_vcu118
git submodule update --init garnet-firesim/
cd $PC_DIR
bash scripts/patches/do-apply-garnet-patches.sh
bash scripts/patches/do-apply-firesim-patches.sh
