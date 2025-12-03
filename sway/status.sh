#!/usr/bin/env bash
echo "$(date +'%Y-%m-%d %H:%M') | RAM: $(free -h | awk '/Mem:/ {print $3 "/" $2}') | CPU: $(awk '/^cpu / {printf("%.1f%%", ($2+$4)*100/($2+$4+$5))}' /proc/stat)"
