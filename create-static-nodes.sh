#!/bin/bash
#this file takes the a number as an input and creates a static-nodes.json file for the given
#number of nodes. Current max limit is 7
#output file name will be static-nodes<<passednumber>>.json

count=$1
if [ "$count" == "" ]; then
	echo "Invalid usage - enter the number of nodes"
	exit 1
fi

let lower=count-1
let upper=count+1

FILE="static-nodes$count.json"
# delete any existing file
if [ -f "$FILE" ]; then
	rm $FILE
fi
touch $FILE
echo "[" >> $FILE
echo -n `cat ./permissioned-nodes.json | head -$count | tail -$lower` >> $FILE
echo `cat ./permissioned-nodes.json | head -$upper | tail -1 | tr -s " "| cut -f1 -d","`>> $FILE
echo "]" >> $FILE
