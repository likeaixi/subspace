#!/bin/bash

nohup /root/subspace/subspace-node \
    run \
    --chain gemini-3h \
    --base-path /root/subspace \
    --farmer \
    --rpc-cors  all \
    --rpc-methods  unsafe \
    --rpc-listen-on 0.0.0.0:9944 \
    --rpc-max-connections 500 \
    --name "subspace"  >>/root/subspace/subspace-node-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace node started"
