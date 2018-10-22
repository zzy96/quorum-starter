#!/bin/bash
# e.g.
# ./raft-start-node.sh 1 YES YES 0 full
# count=$1
# nodediscover=$2
# permissioned=$3
# peerid=$4
# gcmode=$5

set -u
set -e
source ./format.sh

start_raft(){
    node=$1
    privmode=$2
    gcmode=$3
    nodediscover=$4
    permissioned=$5
    peerid=$6

    let k=1

    j="$(($node-$k))"

    NETWORK_ID=$(cat genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

    if [ $NETWORK_ID -eq 1 ]
    then
	      echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	      echo "  1337 is the recommend ChainId for Geth private clients."
    fi
    mkdir -p qdata/logs

    if [ "$gcmode" == "full" ]
    then
        ARGS="--gcmode full "
    else
        ARGS="--gcmode archive "
    fi

    if [ "$nodediscover" != "YES" ]
    then
        ARGS+=" --nodiscover "
    fi

    if [ "$permissioned" == "YES" ]
    then
        ARGS+=" --permissioned "
    fi

    ARGS+="--verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"

    if [ "$peerid" != "0" ]
    then
        ARGS+=" --raftjoinexisting $peerid "
    fi
    PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth --datadir qdata/dd$node $ARGS --raftport 5040$node --rpcport 2200$j --port 2100$j --unlock 0 --password passwords.txt 2>>qdata/logs/$node.log &


}
###### main execution #######################################
# input total number of nodes to start (say 4), node is permissioned or not
count=$1
nodediscover=$2
permissioned=$3
peerid=$4
gcmode=$5

if [ "$peerid" == "0" ]
then
    start=1
else
    start=$count
fi

# start the tessera nodes
nohup ./tessera-start-node.sh --nodelow $start --nodehigh $count

# start the geth nodes
for i in $(seq "$start" "$count")
do
    echo "Starting geth node - $i"
    start_raft $i tessera $gcmode $nodediscover $permissioned $peerid
done
