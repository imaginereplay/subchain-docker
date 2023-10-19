#!/bin/bash

# Print environment variables
env

# Update the rpcEndpoint IP address in the config file
#sed -i 's|http://127.0.0.1:16888/rpc|http://mainchain_node:16888/rpc|' /root/metachain_playground/mainnet/mainchain/ethrpc/config.yaml

# Run theta subchain command

cd ~/metachain_playground/mainnet/workspace
thetasubchain start --config=../subchain/validator --password=${MAIN_CHAIN_NODE_PASSWORD}
