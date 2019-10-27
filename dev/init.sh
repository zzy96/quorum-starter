#!/bin/bash
# e.g.
# ./istanbul-init-node.sh [raft/istanbul] 4(maximum 7)  [multiple/single] [tessera/ignore]

set -u
set -e

init_node()
{
    consensus=$1
    nodeid=$2
    count=$3
	  mkdir -p qdata/dd$nodeid/{keystore,geth}
	  echo "[*] Configuring node $nodeid"
	  cp static-nodes$count.json qdata/dd$nodeid/static-nodes.json
		cp static-nodes$count.json qdata/dd$nodeid/permissioned-nodes.json
	  cp keys/key$nodeid qdata/dd$nodeid/keystore
    cp keys/nodekey$nodeid qdata/dd$nodeid/geth/nodekey
    # init geth
    if [ $consensus == "raft" ]
    then
        geth --datadir qdata/dd$nodeid init genesis.json
    elif [ $consensus == "istanbul" ]
    then
        geth --datadir qdata/dd$nodeid init istanbul-genesis.json
    else
        echo "\$1 must be raft or istanbul"
        exit 1
    fi
}

init_tessera()
{
    start=$1
    end=$2
    tessera=$3
    if [ "$tessera" == "tessera" ]
    then
        ./tessera-init-node.sh $start $count
    fi
}

###### main execution #######################################
consensus=$1
count=$2
type=$3

if [ $# -eq 3 ] || [ $4 == "ignore"]
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

# based on the count create the permissioned-nodes.json file
./create-static-nodes.sh $count

echo "$count nodes in static-nodes.json & permissioned-nodes.json"

# check if for multiple or single node mode
if [ "$type" == "multiple" ]
then
    # clean up the directories
    echo "[*] Cleaning up temporary data directories"
    rm -rf qdata

    # init the directories for all node
    for i in $(seq "$count")
    do
        init_node $consensus $i $count
    done
    let lower=1

    # tessera init
    init_tessera $lower $count $tessera
elif [ "$type" == "single" ]
then
    echo "in else"
    # clean up any existing directories
    rm -rf qdata/dd$count
    rm -rf qdata/c$count

    # copy the new static nodes.json as permissioned-nodes.json for already running nodes
    # for d in qdata/dd*
    # do
    #     cp static-nodes$count.json $d/permissioned-nodes.json
    # done

    # init the directory for this node
    init_node $consensus $count $count

    # tessera init
    init_tessera $count $count $tessera
else
    echo "\$3 must be multiple or single"
fi

rm static-nodes$count.json
