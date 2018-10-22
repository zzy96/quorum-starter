#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
torq=`tput setaf 14`
reset=`tput sgr0`
tick(){
	echo "${green}\xE2\x9C\x94${reset}"
}
cross(){
	echo "${red}X${reset}"
}

msg_success(){
    msg=$1
    echo -e "\t\t$(tick)\t ${yellow}$msg${reset}"
}
msg_failure(){
    msg=$1
    echo -e "\t\t$(cross)\t ${red}$msg${reset}"
}
msg_proc(){
    msg=$1
    echo "${torq}## $msg ${reset}"
}

print_network_stats(){
    nodes=`ps -eaf| grep geth |grep -v grep| wc -l`
    tessera=`ps -eaf|grep tessera |grep -v grep|grep "tessera-config"| wc -l`
    echo "---------------------------------------------------------------------------"
    msg_proc "$nodes geth nodes and $tessera tessera processes up"
    echo "---------------------------------------------------------------------------"
    ps -eaf| grep geth| grep -v grep
    ps -eaf| grep tessera| grep -v grep | grep "tessera-config"
    echo "---------------------------------------------------------------------------"
}
print_test_header(){
    consensus=$1
    privacymode=$2
    gcmode=$3
    nodediscover=$4
    permissioned=$5
    echo "############################################################################"
    msg_proc "geth running with following set up:"
    msg_proc "Consensus Engine : $consensus"
    msg_proc "Privacy Engine : $privacymode"
    msg_proc "Caching Mechanism : $gcmode"
    msg_proc "Node Discovery Allowed : $nodediscover"
    msg_proc "Permissioned network #: $permissioned"
    echo "############################################################################"
}

create_trans(){
    # creates set of public and private transaction from node1
    i=10
    for j in $(seq "$i")
    do
        ./runscript.sh "public-contract.js"
        ./runscript.sh "private-contract.js"
    done
}
get_block_num(){
    nid=$1
    currentdir=$(pwd)

    x=$(geth attach ipc:$currentdir/qdata/dd$nid/geth.ipc <<EOF
    var blknum=eth.blockNumber;
    console.log("block number is :["+blknum+"]");
    exit;
    EOF
     )
    blocknum=`echo $x| tr -s " "| cut -f2 -d "[" | cut -f1 -d"]"`
    echo $blocknum
}

check_sync_success(){
    node1=$1
    node2=$2
    mode=$3

    blockcnt1=$(get_block_num "$node1")
    sleep 2
    blockcnt2=$(get_block_num "$node2")

    if [ "$mode" == "ADD" ]
    then
        if [ "$blockcnt1" -le "$blockcnt2" ]
        then
            msg_success "Sync successful for peer $node2!!!"
        else
            msg_failure "Sync failed for peer $node2 !!!!!"
        fi
    else
        if [ "$blockcnt1" -gt  "$blockcnt2" ]
        then
            msg_success "Removed peer $node2 not syncing with other nodes"
        else
            msg_failure "Sync happening after removal of peer $node2"
        fi
    fi
}
