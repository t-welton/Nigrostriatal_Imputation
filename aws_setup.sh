# download and run this script

#sudo yum update
#sudo yum -y install git
#git clone https://github.com/t-welton/Nigrostriatal_Imputation

# setup environment on aws r5dn.2xlarge with 1024 GiB EBS

git clone https://github.com/hakyimlab/MetaXcan
git clone https://github.com/hakyimlab/summary-gwas-imputation

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sudo bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3
export PATH=$PATH:/opt/miniconda3/bin
conda config --remove channels defaults
conda config --add channels conda-forge
conda env create -f MetaXcan/software/conda_env.yaml
conda init bash
bash

# download data

mkdir ~/data
mkdir ~/data/dis
mkdir ~/data/rep
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
tar –xvzf ~/data/QSMandT2s_IDPs.tar.gz -C ~/data/dis
tar –xvzf ~/data/QSMandT2s_IDPs_repro.tar.gz -C ~/data/rep

# download gtex models

mkdir ~/models
wget -P ~/models https://zenodo.org/record/3518299/files/mashr_eqtl.tar
tar –xvzf ~/models/mashr_eqtl.tar -C ~/models

# download liftover chainfile
mkdir ~/liftover
wget -P ~/liftover https://hgdownload.soe.ucsc.edu/gbdb/hg19/liftOver/hg19ToHg38.over.chain.gz

# download 1000g reference data / 11GB
mkdir ~/reference_panel
wget -P ~/reference_panel https://uchicago.app.box.com/s/eku1me6pxkakm7nlf5a7ydpwe8j6849a/folder/141046310030

# run imputation script
#chmod u+x Nigrostriatal_Imputation/spredixcan_nigro_aws.sh
#./Nigrostriatal_Imputation/spredixcan_nigro_aws.sh
