#!/bin/bash
# e.g.
# ./istanbul-init-node.sh 4 YES cluster (maximum 7)

set -u
set -e

init_istanbul_node()
{
    nodeid=$1
    permissioned=$2
    count=$3
	  mkdir -p qdata/dd$nodeid/{keystore,geth}
	  echo "[*] Configuring node $nodeid (permissioned = $permissioned)"
	  cp static-nodes$count.json qdata/dd$nodeid/static-nodes.json
	  if [ "$permissioned" == "YES" ]; then
		    cp static-nodes$count.json qdata/dd$nodeid/permissioned-nodes.json
	  fi
	  cp keys/key$nodeid qdata/dd$nodeid/keystore
    cp keys/nodekey$nodeid qdata/dd$nodeid/geth/nodekey
	  geth --datadir qdata/dd$nodeid init istanbul-genesis.json
}
init_tessera()
{
    start=$1
    end=$2
    ./tessera-init-node.sh $start $count
}

###### main execution #######################################
# input total number of nodes to start (say 4), node is permissioned or not
count=$1
permissioned=$2
inittype=$3

# based on the count create the permissioned-nodes.json file
./create-static-nodes.sh $count

echo $count

#clean up the directories
# check if for cluster  or single node mode
if [ "$inittype" == "cluster" ]; then
    echo "[*] Cleaning up temporary data directories"
    rm -rf qdata

    # init process
    for i in $(seq "$count")
    do
        init_istanbul_node $i $permissioned $count
    done
    let lower=1
    init_tessera $lower $count
else
    echo "in else"
    # clean up any existing directories
    rm -rf qdata/dd$count
    rm -rf qdata/c$count
    # copy the new static nodes.json as permissioned-nodes.json for already running nodes
    # if uncomment, no manual add node required
    # if [ "$permissioned" == "YES" ]
    # then
    #     for d in qdata/dd*
    #     do
    #         cp static-nodes$count.json $d/permissioned-nodes.json
    #     done
    # fi
    # init the directories for this node
    init_istanbul_node $count $permissioned $count
    # tessera init
    init_tessera $count $count
fi

rm static-nodes$count.json
