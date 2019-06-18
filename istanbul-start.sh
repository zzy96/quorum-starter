#!/bin/bash
# e.g.
# ./istanbul-start.sh 4 YES 0
# count=$1
# permissioned=$2
# peerid=$3

set -u
set -e
source ./format.sh

start_istanbul(){
    node=$1
    privmode=$2
    permissioned=$3

    let k=1

    j="$(($node-$k))"

    NETWORK_ID=$(cat istanbul-genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')
    ARGS=""

    if [ $NETWORK_ID -eq 1 ]
    then
	      echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	      echo "  1337 is the recommend ChainId for Geth private clients."
    fi
    mkdir -p qdata/logs

    if [ "$permissioned" == "YES" ]
    then
        ARGS+=" --permissioned "
    fi

    if [ $node -gt 4 ]
    then
        ARGS+=" --nodiscover --verbosity 5 --istanbul.blockperiod 3 --networkid $NETWORK_ID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul "
    else
        ARGS+=" --nodiscover --verbosity 5 --istanbul.blockperiod 3 --networkid $NETWORK_ID --syncmode full --mine --minerthreads 1 --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul "
    fi


    echo "PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth --datadir qdata/dd$node $ARGS --rpcport 2200$j --port 2100$j --unlock 0 --password passwords.txt 2>>qdata/logs/$node.log &"
    PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth --datadir qdata/dd$node $ARGS --rpcport 2200$j --port 2100$j --unlock 0 --password passwords.txt 2>>qdata/logs/$node.log &

}
###### main execution #######################################
# input total number of nodes to start (say 4), node is permissioned or not
count=$1
permissioned=$2
peerid=$3

if [ "$peerid" == "0" ]
then
    start=1
else
    start=$count
fi

# start the tessera nodes
./tessera-start-node.sh --nodelow $start --nodehigh $count

# start the geth nodes
for i in $(seq "$start" "$count")
do
    echo "Starting geth node - $i"
    start_istanbul $i tessera $permissioned
done
