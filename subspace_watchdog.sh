#!/bin/bash

# 被守护进程的启动命令
COMMAND="/root/subspace/subspace-farmer"

# 守护进程的日志文件
LOGFILE="/root/subspace/daemon_watchdog.log"

# 检查间隔（秒）
INTERVAL=60

# 记录日志函数
log() {
    echo "$(date): $1" >> "$LOGFILE"
}

# 检查并重启进程的函数
watchdog() {
    while true; do
        # 检查进程是否在运行
        pgrep -f "$COMMAND" > /dev/null
        if [ $? -ne 0 ]; then
            # 进程未运行，重启进程
            log "Process not running. Restarting $COMMAND"
            /root/subspace/subspace_wuhan.sh
            log "Process restarted"
        fi
        sleep "$INTERVAL"
    done
}

# 守护化脚本
daemonize() {
    # 分叉脚本以在后台运行
    if [ "$1" != "nodaemon" ]; then
        "$0" "nodaemon" &
        exit 0
    fi

    # 重定向标准输入、输出和错误到 /dev/null
    exec 0</dev/null
    exec 1>/dev/null
    exec 2>/dev/null

    # 启动守护进程功能
    watchdog
}

# 运行守护化函数
daemonize "$1"
