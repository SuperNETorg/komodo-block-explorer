#!/bin/bash


echo "logout of this shell, log back in and run: bash block-explorer-part2.sh"


# switch node setup with nvm
nvm install v4

# install zeromq
sudo apt-get install libzmq3-dev

# install bitcore
sudo npm install -g bitcore

npm install str4d/bitcore-node-zcash

# setup bitcore
./node_modules/bitcore-node-zcash/bin/bitcore-node create beta2-explorer

cd beta2-explorer

# point zcash at testnet
cat << EOF > bitcore-node.json
{
  "network": "testnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zcash",
    "insight-ui-zcash",
    "lweb"
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

../node_modules/bitcore-node-zcash/bin/bitcore-node install str4d/insight-api-zcash str4d/insight-ui-zcash


# start block explorer
echo "To start the block explorer, from you homedir issue the command: ./beta2-explorer/node_modules/bitcore-node-zcash/bin/bitcore-node start"
