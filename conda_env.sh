

git clone https://github.com/luoyunan/ECNet
cd ECNet

conda_env='ECNet'
conda create -y -n $conda_env python==3.7.10
conda activate $conda_env


pip install pip -U
pip config set global.index-url https://mirrors.bfsu.edu.cn/pypi/web/simple
pip install -r requirements.txt

export PYTHONPATH=$PWD:$PYTHONPATH
echo "export PYTHONPATH=$PYTHONPATH" >>~/.bashrc

cho "channels:
  - defaults
  - https://levinthal:paradox@conda.graylab.jhu.edu
  - conda-forge
show_channel_urls: true
default_channels:
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/main
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/r
  - https://mirrors.bfsu.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.bfsu.edu.cn/anaconda/cloud
  msys2: https://mirrors.bfsu.edu.cn/anaconda/cloud
  bioconda: https://mirrors.bfsu.edu.cn/anaconda/cloud
  menpo: https://mirrors.bfsu.edu.cn/anaconda/cloud
  pytorch: https://mirrors.bfsu.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.bfsu.edu.cn/anaconda/cloud
report_errors: false
pkgs_dirs:
  - $HOME/.conda/pkgs" > $HOME/.condarc


conda clean -i
conda install -y -c pytorch  cudatoolkit=11.4
conda install -y -c bioconda hmmer==3.3.2 hhsuite==3.3.0 kalign2==2.04


# CCMPred
cd
git clone --recursive https://github.com/soedinglab/CCMpred.git
cd CCMPred

# CCMpred use cuda.
export PATH=/usr/local/cuda-11.5/bin:$PATH
cmake .
make
# append CCMpred bin path to PATH
cd bin
echo export PATH=/usr/local/cuda-11.5/bin:"$PWD":'$PATH' >> ~/.bashrc