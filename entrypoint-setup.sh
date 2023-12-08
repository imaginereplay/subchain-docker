#!/bin/bash

# Change to the specified directory
cd ~/metachain_playground/mainnet/mainchain/walletnode

# Download the snapshot file
wget -O ./snapshot $(curl -k https://mainnet-data.thetatoken.org/snapshot)

# Download the configuration file
curl -k --output ./config.yaml $(curl -k 'https://mainnet-data.thetatoken.org/config?is_guardian=true')

# Execute the command passed to the docker container
exec "$@"
