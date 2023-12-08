#!/bin/bash

# Print environment variables
env

# Update the rpcEndpoint IP address in the config file
sed -i 's|http://127.0.0.1:16888/rpc|http://mainchain_node:16888/rpc|' /root/metachain_playground/mainnet/mainchain/ethrpc/config.yaml
# Replace localhost with 0.0.0.0 to allow connection from other containers
sed -i \
    -e 's|httpAddress: "127.0.0.1"|httpAddress: "0.0.0.0"|' \
    -e 's|wsAddress: "127.0.0.1"|wsAddress: "0.0.0.0"|' \
    /root/metachain_playground/mainnet/mainchain/ethrpc/config.yaml

# Run theta command
exec theta-eth-rpc-adaptor start --config=../mainchain/ethrpc
