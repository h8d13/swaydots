#!/usr/bin/env bash

interface=$(ip -o -4 route show to default | awk '{print $5}')
procs=$(ls /proc | grep -E '^[0-9]+$' | wc -l)
dt=$(date +'%Y-%m-%d-%H:%M')
ram_use=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
cpu_use=$(awk '/^cpu / {printf("%.1f%%", ($2+$4)*100/($2+$4+$5))}' /proc/stat)
tx=$(numfmt --to=iec < /sys/class/net/$interface/statistics/tx_bytes)
rx=$(numfmt --to=iec < /sys/class/net/$interface/statistics/rx_bytes)

echo "USR: $USER | DT: $dt | PSC: $procs | RAM: $ram_use | CPU: $cpu_use | NET: ↑$tx ↓$rx "
