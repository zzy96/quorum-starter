#!/bin/bash
# e.g.
# ./istanbul-start.sh [raft/istanbul] 4(maximum 7) [multiple/single] [tessera/ignore] [raftId]

set -u
set -e

start_raft(){
    node=$1
    tessera=$2
    raftId=$3

    let k=1
    j="$(($node-$k))"

    # use chainid as networkid
    NETWORK_ID=$(cat istanbul-genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

    # initialize mandatory args
    ARGS=" --datadir qdata/dd$node --raft --raftport 5040$node --port 2100$j "
    # add additional starting args
    ARGS+=" --networkid $NETWORK_ID --nodiscover --verbosity 5 --rpc --rpcaddr 0.0.0.0 --rpcport 2200$j --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --rpccorsdomain=* --rpcvhosts=* --ws --wsaddr 0.0.0.0 --wsport 2300$j --wsorigins=* --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints "
    # ARGS+=" --permissioned "
    ARGS+=" --unlock 0 --password passwords.txt "
    # Quorum v2.6.0 onwards
    ARGS+=" --allow-insecure-unlock "
    # if [ $j -eq 0 ]
    # then
    #   # ARGS+=" --graphql "
    #   # AGRS+=" --signer /Users/ZZY/Library/Signer/clef.ipc "
    # fi

    if [ $NETWORK_ID -eq 1 ]
    then
	      echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	      echo "  1337 is the recommend ChainId for Geth private clients."
    fi
    mkdir -p qdata/logs

    if [ "$raftId" != "0" ]
    then
        ARGS+=" --raftjoinexisting $raftId "
    fi

    if [ "$tessera" == "tessera" ]
    then
        cmd="PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth $ARGS 2>>qdata/logs/$node.log &"
        # cmd="CONTRACT_EXTENSION_SERVER=http://localhost:908$node PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth $ARGS 2>>qdata/logs/$node.log &"
        echo $cmd
        eval $cmd
    else
        cmd="PRIVATE_CONFIG=ignore nohup geth $ARGS 2>>qdata/logs/$node.log &"
        echo $cmd
        eval $cmd
    fi
}

start_istanbul(){
    node=$1
    tessera=$2

    let k=1
    j="$(($node-$k))"

    # use chainid as networkid
    NETWORK_ID=$(cat istanbul-genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')

    # initialize mandatory args
    ARGS=" --datadir qdata/dd$node --istanbul.blockperiod 1 --port 2100$j "
    # add additional starting args
    ARGS+=" --networkid $NETWORK_ID --nodiscover --verbosity 5 --rpc --rpcaddr 0.0.0.0 --rpcport 2200$j --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpccorsdomain=* --rpcvhosts=* --ws --wsaddr 0.0.0.0 --wsport 2300$j --wsorigins=* --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --emitcheckpoints "
    # ARGS+=" --permissioned "
    ARGS+=" --unlock 0 --password passwords.txt "
    # Quorum v2.6.0 onwards
    ARGS+=" --allow-insecure-unlock "

    if [ $NETWORK_ID -eq 1 ]
    then
	      echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	      echo "  1337 is the recommend ChainId for Geth private clients."
    fi
    mkdir -p qdata/logs

    # special flags for istanbul miners
    if [ $node -le 4 ]
    then
        ARGS+=" --syncmode full --mine --minerthreads 1 "
    fi

    if [ "$tessera" == "tessera" ]
    then
        cmd="PRIVATE_CONFIG=qdata/c$node/tm.ipc nohup geth $ARGS 2>>qdata/logs/$node.log &"
        echo $cmd
        eval $cmd
    else
        cmd="PRIVATE_CONFIG=ignore nohup geth $ARGS 2>>qdata/logs/$node.log &"
        echo $cmd
        eval $cmd
    fi
}

###### main execution #######################################
consensus=$1
count=$2
type=$3

if [ $# -eq 3 ] || [ $4 == "ignore" ]
then
    echo "Tessera not used"
    tessera="ignore"
elif [ $4 == "tessera" ]
then
    echo "Tessera used"
    tessera=$4
else
    echo "\$4 must be tessera or ignore"
    exit 1
fi

raftId=0
if [ "$type" == "multiple" ]
then
    start=1
elif [ "$type" == "single" ]
then
    start=$count
    if [ $# -eq 5 ]
    then
        raftId=$5
    fi
else
    echo "\$3 must be multiple or single"
fi

# start the tessera nodes
if [ "$tessera" == "tessera" ]
then
    ./tessera-start-node.sh --nodelow $start --nodehigh $count
fi

# start the geth nodes
for i in $(seq "$start" "$count")
do
    echo "Starting geth node - $i"
    # start raft/ istanbul
    if [ $consensus == "raft" ]
    then
        start_raft $i $tessera $raftId
    elif [ $consensus == "istanbul" ]
    then
        start_istanbul $i $tessera
    else
        echo "\$1 must be raft or istanbul"
        exit 1
    fi
done
