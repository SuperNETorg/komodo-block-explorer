#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v4

echo "---------------"
echo "installing bitcore dependencies"
echo

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing zcash patched bitcore"
echo 
npm install str4d/bitcore-node-zcash

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-zcash/bin/bitcore-node create zcash-explorer

cd zcash-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-zcash/bin/bitcore-node install str4d/insight-api-zcash str4d/insight-ui-zcash


echo "---------------"
echo "creating config files"
echo

# point zcash at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
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
        "exec": "zcashd"
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


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the beta2-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-zcash/bin/bitcore-node start"
