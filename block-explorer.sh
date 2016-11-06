#!/bin/bash

echo "downloading part2"
echo

wget https://raw.githubusercontent.com/radix42/zcash-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install zcash dependencies:

echo "installing zcash"
echo

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

# download zcash source from fork with block explorer patches
git clone https://github.com/str4d/zcash.git

cd zcash

# switch to sprout version of source code; this will change in the future
git checkout v1.0.0-bitcore-3

# download proving parameters
./zcutil/fetch-params.sh

# build patched zcash
./zcutil/build.sh -j$(nproc)

# install lintian
sudo apt-get -y install lintian

# package zcash
./zcutil/build-debian-package.sh

# install zcash
sudo dpkg -i zcash-1.0.0-sprout-amd64.deb

echo "---------------"
echo "installing node and npm"
echo

# install node and dependencies
cd ..
sudo apt-get -y install npm

echo "---------------"
echo "installing nvm"
echo

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "logout of this shell, log back in and run:"
echo "bash block-explorer-part2.sh"

