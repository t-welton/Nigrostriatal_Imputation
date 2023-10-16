# setup env - t3a.2xlarge / EBS

sudo yum update
sudo yum -y install git

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
export PATH=$PATH:/opt/miniconda3/bin

git clone https://github.com/hakyimlab/MetaXcan
git clone https://github.com/hakyimlab/summary-gwas-imputation

conda config --remove channels defaults
conda config --add channels conda-forge

conda env create -f MetaXcan/software/conda_env.yaml
conda init bash
bash

# download
mkdir ~/data
wget -P ~/data https://www.fmrib.ox.ac.uk/ukbiobank/gwas_resources/QSMandT2s_IDPs.tar.gz	#10GB
wget -P ~/data https://www.fmrib.ox.ac.uk/ukbiobank/gwas_resources/QSMandT2s_IDPs_repro.tar.gz	#10GB
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats/1440.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/repro/1440.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats/1441.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/repro/1441.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats/1442.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/repro/1442.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats/1443.txt.gz
wget -P ~/data https://open.win.ox.ac.uk/ukbiobank/big40/release2/repro/1443.txt.gz

tar –xvzf ~/data/QSMandT2s_IDPs.tar.gz -C ~/data
tar –xvzf ~/data/QSMandT2s_IDPs_repro.tar.gz  -C ~/data




