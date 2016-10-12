#!/bin/bash
sudo apt-get -y update

# Install zcash dependencies:

sudo apt-get install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake

# download zcash source from fork with block explorer patches
git clone https://github.com/str4d/zcash.git

cd zcash

# switch to beta2 version of source code; this will change in the future
git checkout v1.0.0-beta2-bitcore-3

# download proving parameters
./zcutil/fetch-params.sh

# build patched zcash
./zcutil/build.sh -j$(nproc)

# create config file for zcashd
mkdir ~/.zcash


# install node and dependencies
cd ..
sudo apt-get install npm

# install nvm
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash

# switch node setup with nvm
nvm install v4

# install zeromq
sudo apt-get install libzmq3-dev

# install bitcore
npm install -g bitcore

npm install str4d/bitcore-node-zcash

# setup bitcore
./node_modules/bitcore-node-zcash/bin/bitcore-node create beta2-explorer

cd beta2-explorer
../node_modules/bitcore-node-zcash/bin/bitcore-node install str4d/insight-api-zcash str4d/insight-ui-zcash

# point zcash at testnet
cat << EOF > bitcore-node.json
{
  "network": "testnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zcash",
    "insight-ui-zcash",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "/home/ubuntu/zcash/src/zcashd"
      }
    }
  }
}
EOF

# create zcash.conf
cat << EOF > data/zcash.conf
testnet=1
addnode=betatestnet.z.cash
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:28332
zmqpubhashblock=tcp://127.0.0.1:28332
rpcallowip=127.0.0.1
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
EOF

# start block explorer
echo "To start block explorer, from you homedir issue command: node_modules/bitcore-node-zcash/bin/bitcore-node start"
