#!/usr/bin/env bash
echo "$(date +'%Y-%m-%d %H:%M') | RAM: $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
