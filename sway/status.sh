#!/usr/bin/env bash
echo "USR: $USER | DT: $(date +'%Y-%m-%d %H:%M') | PSC: $(ps aux | wc -l) | RAM: $(free -h | awk '/Mem:/ {print $3 "/" $2}') | CPU: $(awk '/^cpu / {printf("%.1f%%", ($2+$4)*100/($2+$4+$5))}' /proc/stat) | NET: ↑$(cat /sys/class/net/eth0/statistics/tx_bytes | numfmt --to=iec) ↓$(cat /sys/class/net/eth0/statistics/rx_bytes | numfmt --to=iec) "
