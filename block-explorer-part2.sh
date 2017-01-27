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
echo "installing komodo patched bitcore"
echo 
npm install supernetorg/bitcore-node-komodo

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-komodo/bin/bitcore-node create komodo-explorer

cd komodo-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-komodo/bin/bitcore-node install supernetorg/insight-api-komodo supernetorg/insight-ui-komodo


echo "---------------"
echo "creating config files"
echo

# point komodo at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-komodo",
    "insight-ui-komodo",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "$HOME/.komodo",
        "exec": "komodod"
      }
    }
  }
}

EOF

# create komodo.conf
mkdir .komodo
touch .komodo/komodo.conf

cat << EOF > $HOME/.komodo/komodo.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:8332
zmqpubhashblock=tcp://127.0.0.1:8332
rpcallowip=127.0.0.1
rpcport=8232
rpcuser=bitcoin
rpcpassword=local321
uacomment=bitcore
showmetrics=0

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the komodo-explorer directory issue the command:"
echo " nvm use v4; ./node_modules/bitcore-node-komodo/bin/bitcore-node start"
