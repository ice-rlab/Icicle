# Icicle IISWC2025 AE

## Initial repository setup

### OS
`Ubuntu 22.04.5 LTS`

### Prerequisites
```
git clone https://github.com/ice-rlab/Icicle.git
cd Icicle
```

```
sudo apt-get update && sudo apt-get install git make gcc screen 
```
### Conda install

```
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
```
Make sure to install conda in a directory with plenty of disk space.

```
bash Miniforge3.sh
```


Restart your shell session.
```
source ~/.bashrc
```

```
conda install -y -n base conda-libmamba-solver
conda config --set solver libmamba
conda install -y -n base conda-lock==1.4.0
conda activate base
```


## Run setup

```
sudo chmod +r /boot/vmlinuz-*
```

Takes a 1-2 hours to run. If crashes, see common issues below
```
bash setup.sh  --skip=fpga
```


### Sudo priviledges (without password)
Run:
```
sudo visudo
```

Add this to the bottom of the file: 

```
$USER ALL=(ALL) NOPASSWD: ALL
```


### Setup Firesim ssh agent

```
cd ~/.ssh
ssh-agent -s > AGENT_VARS
source ./AGENT_VARS
ssh-add firesim.pem
```

### Run scripts
```
source env.sh
```

```
bash plots-iiswc-2025-ae.sh
```


```
bash run-iiswc-2025-ae.sh
```


## Common Issues
### Instance livness error

Return Firesim ssh agent setup

```
cd ~/.ssh
ssh-agent -s > AGENT_VARS
source ./AGENT_VARS
ssh-add firesim.pem
```

### Guestmount
If you see error related to ‘guestmount’, run command again: 
```
sudo chmod +r /boot/vmlinuz-*
```
and rerun setup command.

### Firtool not found
If you see firtool issue, try:
```
conda config --add channels ucb-bar
conda install firtool
```

### Verilog compile error

Somtimes verilog/chisel builds have transient errors. Run 
`rm -f ./platforms/chipyard/sims/firesim/sim/generated-src/` 
to clear the generated code and restart the run/meta simulation. 





