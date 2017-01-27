#!/bin/bash

echo "downloading part2"
echo

wget https://raw.githubusercontent.com/supernetorg/komodo-block-explorer/master/block-explorer-part2.sh

echo "---------------"
# Install komodo dependencies:

echo "installing komodo"
echo

sudo apt-get -y install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

# download zcash source from fork with block explorer patches
git clone https://github.com/supernetorg/komodo-bitcore.git komodo

cd komodo

# switch to sprout version of source code; this will change in the future
git checkout komodo-insight

# download proving parameters
./zcutil/fetch-params.sh

# build patched komodo
./zcutil/build.sh -j$(nproc)

# install komodo
sudo cp src/komodod /usr/local/bin/
sudo cp src/komodo-cli /usr/local/bin/

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
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

echo "logout of this shell, log back in and run:"
echo "bash block-explorer-part2.sh"

