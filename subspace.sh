#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

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

git clone https://github.com/subspace/subspace.git && cd subspace && TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && git switch $TAG

cargo build \
    --profile production \
    --bin subspace-node \
    --bin subspace-farmer

nohup ./target/production/subspace-farmer \
	 farm \
	 --node-rpc-url ws://111.46.8.20:9944 \
	 --reward-address stC1RQiySPW7GYu6xAn1x7unx86NuthF9shzQnjEGPbF5ps3P \
	 --metrics-endpoints 127.0.0.1:9081 \
	 path=/nvme0n1/subspace,size=3600G \
	 path=/nvme1n1/subspace,size=3600G \
	 path=/nvme2n1/subspace,size=3600G \
	 path=/nvme3n1/subspace,size=3600G \
	 path=/nvme4n1/subspace,size=3600G \
	 >>./subspace-farmer-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace farmer started"