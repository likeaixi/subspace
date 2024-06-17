#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

nohup /root/subspace-farmer \
	 farm \
	 --node-rpc-url ws://192.168.0.53:9944 \
	 --reward-address stC1RQiySPW7GYu6xAn1x7unx86NuthF9shzQnjEGPbF5ps3P \
	 path=/data1/subspace,size=1800G \
   path=/data2/subspace,size=1800G \
   path=/data3/subspace,size=1800G \
   path=/data4/subspace,size=1800G \
	 >>/root/subspace-farmer-`date +%Y-%m-%d`.log  2>&1 &

echo "[`date '+%Y-%m-%d %H:%M:%s'`] subspace farmer started"