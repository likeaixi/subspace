#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

nohup ./subspace-farmer \
	 farm \
	 --node-rpc-url ws://111.46.8.35:9944 \
	 --reward-address stC1RQiySPW7GYu6xAn1x7unx86NuthF9shzQnjEGPbF5ps3P \
	 --metrics-endpoints 127.0.0.1:9081 \
	 path=/nvme0n1/subspace,size=3600G \
	 path=/nvme1n1/subspace,size=3600G \
	 path=/nvme2n1/subspace,size=3600G \
	 path=/nvme3n1/subspace,size=3600G \
	 path=/nvme4n1/subspace,size=3600G \
	 >>./subspace-farmer-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace farmer started"