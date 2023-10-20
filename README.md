# theta-solo-staking
Docker images for theta solo staking

# Solo Staking

# Setup for the Mainnet Environment

**IMPORTANT**: The following instructions are currently being revised and are a WORK IN PROGRESS. Please proceed with caution and be aware that changes may be ongoing.
If any questions arise during the setup process please email [support@imaginereplay.org](mailto:support@imaginereplay.org) or contact us on #validator-support channel on discord.

**Reward mechanism**:
To incentivize all validators in the operation of the subchain, we have set the Staker reward of 10 RPLAY tokens per block. These blocks are generated every 7 seconds, and the Theta protocol calculates rewards for each staker or validator based on their staked RPLAY tokens. The more tokens staked, the higher the rewards for the staker.


### Before you Proceed:
We highly encourage going through following documentation before you proceed with main net setup:
- [Replay Whitepaper](https://assets-cdn.imaginereplay.com/docs/Imagine-Replay-Whitepaper-latest.pdf)
- [Theta Metachain Whitepaper](https://assets.thetatoken.org/theta-mainnet-4-whitepaper.pdf)
- [Theta Subchain Testnet Setup](https://github.com/thetatoken/theta-metachain-guide/blob/master/docs/2-testnet/manual-flow/1-setup.md)

### Overview of Setting up Replay validator:
This document offers an overview of launching a validator to be part of Replay subchain. At a high level, the process involves the following steps:
- **Requirements**: All the hardware requirements and tokens needed to start and stake into a validator.
- **Set up**: This involves setting up all the binaries that are needed to run main chain node and sub chain node. You run this only once. You will set up main chain node, main chain eth rpc and sub chain binaries. You will also set up a workspace folder with theta metachain guide which runs the scripts from here - [Theta Metachain Guide](https://github.com/thetatoken/theta-metachain-guide)
- **Run the node in read only mode**: This phase precedes staking. Once this setup is complete, your node is operational, connecting to peers to confirm block finalization. Staking rewards won't be visible at this stage, as no RPLAY tokens have been staked yet. Ensure all four processes are functioning without issues and that you observe the expected output before moving forward.  
- **Staking to Validator**: In this phase, RPLAY tokens are staked within the validator, enabling the staker to start accumulating rewards. When completed, your validator should be visible in the list of nodes on the subchain explorer. This signals that other stakers can commence depositing their stakes into your validator.

## Requirements
You need to have a machine with following requirements and periodically monitor if all the processes are running as expected. These are recommended by Theta team to run a validator as part of Replay sub chain:

### Hardware Minimum Requirements:

Please ensure that you utilize a dedicated machine solely for running your validator. Running other software on the same machine is discouraged, as these processes demand a significant amount of processing power and bandwidth.

- Memory: 16 GB RAM
- CPU: 8 cores
- Storage Disk: 1 TB SSD
- Network Bandwidth: 200Mbps symmetrical commercial network
- Operating System: Ubuntu

You may use AWS, Google or any other cloud hosting services that can satisfy above requirements. For example - m6a.2xlarge on AWS with added 1 TB SSD storage will give you the right instance.

### Admin wallet creation:

First, please set up an admin wallet. You can generate it using the `thetacli key new` command or through the [Theta Web Wallet](https://wallet.thetatoken.org/unlock/keystore-file). If you generate the wallet using `thetacli key new`, it will automatically place the keystore file under `~/.thetacli/keys/encrypted/`. If you generate the key using the Theta Web Wallet, please copy the keystore file to the same folder.

### Admin requirements:

In addition to the hardware requirements, you will need the following tokens:
- 1000 wTheta: If you have THETA tokens, they can be wrapped on the Theta Wallet.
- 20,000 TFUEL + additional to cover gas fees : This amount is required to cover cross-chain transfers that require TFUEL. Additional gas fees is to perform deposit stake transaction. 
- At least 1 RPLAY token :)
