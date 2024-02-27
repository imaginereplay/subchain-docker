# Steps to run Mainchain and Subchain via Docker

## Prerequisites
- [Docker](https://docs.docker.com/engine/install/)
- [Admin Wallet Creation](https://github.com/imaginereplay/replay/blob/main/docs/SoloStaking.md#admin-wallet-creation)
- Open Ports
Subchain Node - Open Port: 12100
Sub chain ETH RPC adapter - Open Port: 16900
***
## Help
Please reach out on [Discord](https://discord.gg/QH4X6ZnA) for any assistance on docker setup.
***
# Docker installation
## Step - 1
This should be run only once for initial setup. The below command will install required binaries, create docker volume and download latest snapshot of Mainnet chain. It's best to isolate the docker containers in separate network for better security and interoperability.

Creating the docker network for all containers that will be deployed for Mainnet.
```
docker network create -d bridge mainnet
```

Create directory to store the keystore file

```
mkdir ~/mainnet-docker
```

Copy the wallet keystore file within the folder created above ```~/mainnet-docker/```

Run the initial setup
```
cd ~/mainnet-docker && \
docker run \
-v meta_volume:/root/metachain_playground \
-v ./<WalletAddress.keystore>:/root/.thetacli/keys/encrypted/<WalletAddress.keystore> \
imaginereplayorg/replay-setup
```

Replace <WalletAddress.keystore> with keystore file that was downloaded and copied above. Wait until the setup is complete and the snapshot download is complete. You may then kill the container by using ```CTRL+Z``` or ```CTRL+X```

***
## Step - 2
Run the Mainchain node

```
docker run -d \
-e MAIN_CHAIN_NODE_PASSWORD=<YOUR_MAIN_CHAIN_NODE_PASSWORD> \
--hostname mainchain_node \
--network mainnet \
--name mainchain_node \
-v meta_volume:/root/metachain_playground \
-v ./<WalletAddress.keystore>:/root/.thetacli/keys/encrypted/<WalletAddress.keystore> \
imaginereplayorg/theta-mainchain
```
Replace <WalletAddress.keystore> with keystore file that was downloaded and copied above.
Wait until the Main Chain walletnode gets insync with the network. This may take some time (e.g. 1-2 hours). You can run the following command to check its synchronization status. If in the output says "syncing": false it means the node is synced to the latest block.

``` 
docker logs mainchain_node 
docker exec -it mainchain_node bash
thetacli query status 
```
***
## Step - 3
After the Main Chain walletnode is in-sync with the network, run the following command to start the Mainchain ETHRPC
```
docker run -d \
--hostname mainchain_ethrpc \
--network mainnet \
--name mainchain_ethrpc \
-v meta_volume:/root/metachain_playground \
-v ./<WalletAddress.keystore>:/root/.thetacli/keys/encrypted/<WalletAddress.keystore> \
imaginereplayorg/theta-mainchain-ethrpc
```
Replace <WalletAddress.keystore> with keystore file that was downloaded and copied above. To check the conatiner logs, use the command below

``` 
docker logs mainchain_ethrpc 
```
***
## Step - 4
Run the Sub Chain ETH RPC
```
docker run -d \
--hostname subchain_ethrpc \
--network mainnet \
--name subchain_ethrpc \
-p 12100:12100 \
-v meta_volume:/root/metachain_playground \
-v ./<WalletAddress.keystore>:/root/.thetacli/keys/encrypted/<WalletAddress.keystore> \
imaginereplayorg/replay-subchain-ethrpc
```
 To check the conatiner logs, use the command below

``` 
docker logs subchain_ethrpc 
```
***
## Step - 5
Run the Sub Chain Validator
```
docker run -d \
-e MAIN_CHAIN_NODE_PASSWORD=<YOUR_MAIN_CHAIN_NODE_PASSWORD> \
--hostname subchain_node \
--network mainnet \
--name subchain_node \
-p 16900:16900 \
-v meta_volume:/root/metachain_playground \
imaginereplayorg/replay-subchain
```
 To check the conatiner logs, use the command below

``` 
docker logs subchain_node 
```
***
## Validation
### 1. Test Main Chain Node
``` 
docker logs mainchain_node 
docker exec -it mainchain_node bash
thetacli query status 
```

### 2. Test Main Chain ETHRPC
``` 
docker logs mainchain_ethrpc 
docker exec -it mainchain_ethrpc bash
curl --location --request POST 'http://mainchain_ethrpc:18888/rpc' \
--header 'Content-Type: application/json' \
--data-raw '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}'
```
The response should look like this:
```
{
  "jsonrpc": "2.0",
  "id": 67,
  "result": "0x16d"
}
```
### 3. Test Sub Chain ETH RPC
``` 
docker logs subchain_ethrpc 
docker exec -it subchain_ethrpc bash
curl --location --request POST 'http://subchain_ethrpc:19888/rpc' --header 'Content-Type: application/json' --data-raw '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":67}'
```
Response should be:
```
{
  "jsonrpc":"2.0",
  "id":67,
  "result":"0x30e375aadebd7205"
}
```
### 4. Test Sub Chain Validator
``` 
docker logs subchain_node 
docker exec -it subchain_node bash
curl --location --request POST 'http://subchain_node:16900/rpc' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": 1,
  "jsonrpc": "2.0",
  "method": "theta.GetStatus",
  "params": [
  ]
}'
```

***
## Update Subchain binaries
To update Subchain binaries to latest version, follow below steps.

Pull latest docker images
```shell
docker pull imaginereplayorg/replay-subchain && \
docker pull imaginereplayorg/replay-subchain-ethrpc 
```

Stop and start the conatiner with new images
```shell
docker stop subchain_ethrpc
docker rm subchain_ethrpc
```
```shell
docker run -d \
--hostname subchain_ethrpc \
--network mainnet \
--name subchain_ethrpc \
-p 12100:12100 \
-v meta_volume:/root/metachain_playground \
-v ./<WalletAddress.keystore>:/root/.thetacli/keys/encrypted/<WalletAddress.keystore> \
imaginereplayorg/replay-subchain-ethrpc
```
***
```shell
docker stop subchain_node
docker rm subchain_node
```

```shell
docker run -d \
-e MAIN_CHAIN_NODE_PASSWORD=<YOUR_MAIN_CHAIN_NODE_PASSWORD> \
--hostname subchain_node \
--network mainnet \
--name subchain_node \
-p 16900:16900 \
-v meta_volume:/root/metachain_playground \
imaginereplayorg/replay-subchain
```