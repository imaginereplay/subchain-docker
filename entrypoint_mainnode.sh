#!/bin/bash

# Print environment variables
env
# Replace localhost with 0.0.0.0 to allow access from other containers
sed -i 's/127.0.0.1/0.0.0.0/g' /root/metachain_playground/mainnet/mainchain/walletnode/config.yaml
# Run theta command
exec theta start --config=../mainchain/walletnode --password=${MAIN_CHAIN_NODE_PASSWORD}
