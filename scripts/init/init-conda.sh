#!/usr/bin/env bash

wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

bash Miniforge3.sh -b -p -u "${HOME}/conda"
rm Miniforge3.sh

source "${HOME}/conda/etc/profile.d/conda.sh"
conda install -y -n base conda-libmamba-solver
conda config --set solver libmamba

conda install -y -n base conda-lock==1.4.0
conda activate base

