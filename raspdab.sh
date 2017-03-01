#!/bin/bash
#
# Installer script for
# 
# * ODR-mmbTools:
#   * ODR-DabMux
#   * auxiliary scripts
#   * the FDK-AAC library with DAB+ patch
#   * ODR-AudioEnc
#   * ODR-PadEnc
#
# and all required dependencies for a
# Raspbian stable system.
#
# Requires: sudo

RED="\e[91m"
GREEN="\e[92m"
NORMAL="\e[0m"

DISTRO="unknown"

if [ $(lsb_release -d | grep -c wheezy) -eq 1 ] ; then
    echo -e $RED
    echo "Warning, debian wheezy is not supported anymore"
    echo -e $NORMAL
    exit 1
elif [ $(lsb_release -d | grep -c jessie) -eq 1 ] ; then
    DISTRO="jessie"
fi

echo
echo "This is the mmbTools installer script for raspbian/debian"
echo "========================================================="
echo
echo "It will install ODR-DabMux, ODR-AudioEnc, ODR-PadEnc"
echo "and all prerequisites to your machine."
echo $DISTRO

if [ "$DISTRO" == "unknown" ] ; then
    echo -e $RED
    echo "You seem to be running something else than"
    echo "debian jessie. This script doesn't"
    echo "support your distribution."
    echo -e $NORMAL
    exit 1
fi

echo -e $RED
echo "This program will use sudo to install components on your"
echo "system. Please read the script before you execute it, to"
echo "understand what changes it will do to your system !"
echo
echo "There is no undo functionality here !"
echo -e $NORMAL

if [ "$UID" == "0" ]
then
    echo -e $RED
    echo "Do not run this script as root !"
    echo -e $NORMAL
    echo "Install sudo, and run this script as a normal user."
    exit 1
fi

which sudo
if [ "$?" == "0" ]
then
    echo "Press Ctrl-C to abort installation"
    echo "or Enter to proceed"

    read
else
    echo -e $RED
    echo -e "Please install sudo first $NORMAL using"
    echo " apt-get -y install sudo"
    exit 1
fi

# Fail on error
set -e

if [ -d dab ]
then
    echo -e $RED
    echo "ERROR: The dab directory already exists."
    echo -e $NORMAL
    echo "This script assumes a fresh initialisation,"
    echo "if you have already run it and wish to update"
    echo "the existing installation, please do it manually"
    echo "or erase the dab folder first."
    exit 1
fi

echo -e "$GREEN Updating debian package repositories $NORMAL"
sudo apt-get -y update

echo -e "$GREEN Installing essential prerquisites $NORMAL"
# some essential and less essential prerequisistes
sudo apt-get -y install build-essential git wget \
 sox alsa-tools alsa-utils \
 automake libtool mpg123 \
 libasound2 libasound2-dev \
 libjack-jackd2-dev jackd2 \
 ncdu vim ntp links cpufrequtils \
 libfftw3-dev \
 libcurl4-openssl-dev \
 libmagickwand-dev \
 libvlc-dev vlc-nox \
 libfaad2 libfaad-dev \
 python-mako python-requests

# this will install boost, cmake and a lot more
sudo apt-get -y build-dep uhd

# stuff to install from source
mkdir dab || exit
cd dab || exit

#COMMENTED OUT FOR RASPDAB
#echo -e "$GREEN Compiling UHD $NORMAL"
#git clone http://github.com/EttusResearch/uhd.git
#pushd uhd
#git checkout release_003_009_001
#mkdir build
#cd build
#cmake ../host
#make
#sudo make install
#popd

#echo -e "$GREEN Downloading UHD device images $NORMAL"
#sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py

sudo apt-get -y install libzmq3-dev libzmq3

#echo -e "$GREEN Installing KA9Q libfec $NORMAL"
#git clone https://github.com/Opendigitalradio/ka9q-fec.git
#pushd ka9q-fec
#./bootstrap
#./configure
#make
#sudo make install
#popd

echo
echo -e "$GREEN PREREQUISITES INSTALLED $NORMAL"
### END OF PREREQUISITES

echo -e "$GREEN Fetching mmbtools-aux $NORMAL"
git clone https://github.com/mpbraendli/mmbtools-aux.git

echo -e "$GREEN Fetching etisnoop $NORMAL"
git clone https://github.com/Opendigitalradio/etisnoop.git
pushd etisnoop
./bootstrap.sh
./configure
make
sudo make install
popd

echo -e "$GREEN Compiling ODR-DabMux $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-DabMux.git
pushd ODR-DabMux
./bootstrap.sh
./configure --enable-input-zeromq --enable-output-zeromq
make
sudo make install
popd

#COMMENTED OUT FOR RASPDAB
#echo -e "$GREEN Compiling ODR-DabMod $NORMAL"
#git clone https://github.com/Opendigitalradio/ODR-DabMod.git
#pushd ODR-DabMod
#./bootstrap.sh
#./configure --enable-zeromq --enable-fft-simd
#make
#sudo make install
#popd

echo -e "$GREEN Compiling fdk-aac library $NORMAL"
git clone https://github.com/Opendigitalradio/fdk-aac.git
pushd fdk-aac
./bootstrap
./configure
make
sudo make install
popd

echo -e "$GREEN Updating ld cache $NORMAL"
# update ld cache
sudo ldconfig


echo -e "$GREEN Compiling ODR-AudioEnc $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-AudioEnc.git
pushd ODR-AudioEnc
./bootstrap
./configure --enable-jack --enable-vlc
make
sudo make install
popd

echo -e "$GREEN Compiling ODR-PadEnc $NORMAL"
git clone https://github.com/Opendigitalradio/ODR-PadEnc.git
pushd ODR-PadEnc
./bootstrap
./configure --enable-jack --enable-vlc
make
sudo make install
popd


echo -e "$GREEN Done installing all tools $NORMAL"
echo -e "All the tools have been dowloaded to the dab/ folder,"
echo -e "compiled and installed to /usr/local"
echo
echo -e "The stable versions have been compiled, i.e. the latest"
echo -e "'master' branch from the git repositories"
echo
echo -e "If you know there is a new release, and you want to update,"
echo -e "you have to go to the folder containing the tool, pull"
echo -e "the latest changes from the repository and recompile"
echo -e "it manually."
echo
echo -e "To pull the latest changes for ODR-DabMux, use:"
echo -e " cd ~/dab/ODR-DabMux"
echo -e " git pull"
echo -e " ./bootstrap.sh"
echo -e " ./configure --enable-input-zeromq --enable-output-zeromq"
echo -e " make"
echo -e " sudo make install"
echo
echo -e "This example should give you the idea. For the options"
echo -e "for compiling the other tools, please see in the debian.sh"
echo -e "script what options are used. Please also read the README"
echo -e "and INSTALL files in the repositories."
