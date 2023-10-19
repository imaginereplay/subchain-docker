#!/bin/bash

# Print environment variables
env
# update validator config
sed -i \
    -e 's|http://localhost:18888/rpc|http://mainchain_ethrpc:18888/rpc|' \
    -e 's|http://localhost:19888/rpc|http://subchain_ethrpc:19888/rpc|' \
    ~/metachain_playground/mainnet/subchain/validator/config.yaml
# update ethrpc config wit hhostname
sed -i 's|http://127.0.0.1:16900/rpc|http://subchain_node:16900/rpc|' ~/metachain_playground/mainnet/subchain/ethrpc/config.yaml
# replace localhost with 0.0.0.0 to allow connections from other containers
sed -i -e 's|httpAddress: "127.0.0.1"|httpAddress: "0.0.0.0"|' -e 's|wsAddress: "127.0.0.1"|wsAddress: "0.0.0.0"|' ~/metachain_playground/mainnet/subchain/ethrpc/config.yaml

# Download sub chain snapshot
cd ~/metachain_playground/mainnet/subchain/validator
wget -O ./snapshot 'https://replay-subchain.s3.amazonaws.com/snapshots/snapshot'

cd ~/metachain_playground/mainnet/subchain/validator
mkdir -p key/encrypted/
#cp ~/.thetacli/keys/encrypted/* key/encrypted/
# Run subchain ethrpc
cd ~/metachain_playground/mainnet/workspace
theta-eth-rpc-adaptor start --config=../subchain/ethrpc
