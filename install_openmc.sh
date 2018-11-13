# install prerequisites
sudo apt install gfortran g++ cmake libhdf5-dev

# Download the source code
git clone https://github.com/mit-crpg/openmc.git

# install on local python
cd openmc && pip setup.py
