#artic-rabv environment  
Modified version of the ARTIC network conda environment for ebola virus bioinformatics, found here Web: http://artic.network/ebov/ebov-it-setup.html

#to install 
-clone the repo  
git clone --recursive https://github.com/artic-network/artic-ebov.git  
  
-Create a custom Conda environment for running software. This may take some time as it will install the required packages and all their dependencies.  
conda env create -f artic-rabv/environment.yml  
cd artic-rabv/fieldbioinformatics
python setup.py install
cd ../..
Although not strictly necessary this will prevent any conflicts with other similar software installed and can be readily removed. You can use this command to activate the environment:
source activate artic-ebov
