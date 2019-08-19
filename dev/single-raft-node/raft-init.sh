#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata

echo "[*] Configuring single node"
mkdir -p qdata/{keystore,geth}
cp static-nodes.json qdata/static-nodes.json
cp key qdata/keystore
cp nodekey qdata/geth/nodekey
geth --datadir qdata init genesis.json