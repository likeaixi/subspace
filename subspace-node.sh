#!/bin/bash

RUSTC_VERSION=nightly-2024-02-29

apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        protobuf-compiler \
        curl \
        git \
        llvm \
        clang \
        automake \
        libtool \
        pkg-config \
        make && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain ${RUSTC_VERSION}

source $HOME/.cargo/env

git clone https://github.com/subspace/subspace.git && cd subspace && git switch gemini-3h-2024-mar-25

cargo build \
    --profile production \
    --bin subspace-node \
    --bin subspace-farmer


nohup /home/hty/subspace/subspace/target/production/subspace-node \
    run \
    --chain gemini-3h \
    --base-path /nvme0n1/subspace \
    --farmer \
    --prometheus-listen-on 127.0.0.1:9080 \
    --rpc-cors  all \
    --rpc-methods  unsafe \
    --rpc-listen-on 0.0.0.0:9944 \
    --rpc-max-connections 500 \
    --name "subspace"  >>/home/hty/subspace/subspace/subspace-node-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace node started"

nohup /home/hty/subspace/subspace/target/production/subspace-farmer farm --reward-address stC1RQiySPW7GYu6xAn1x7unx86NuthF9shzQnjEGPbF5ps3P --metrics-endpoints 127.0.0.1:9081 path=/nvme0n1/subspace,size=3500G path=/nvme1n1/subspace,size=3700G path=/nvme2n1/subspace,size=3700G path=/nvme3n1/subspace,size=3700G path=/nvme4n1/subspace,size=3700G >>/home/hty/subspace/subspace/subspace-farmer-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace farmer started"