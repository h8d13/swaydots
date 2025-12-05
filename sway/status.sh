#!/usr/bin/env bash
interface=$(ip -o -4 route show to default | awk '{print $5}')
procs=$(ls /proc | grep -E '^[0-9]+$' | wc -l)
dt=$(date +'%m-%d-%H:%M')
ram_use=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
load_avg=$(awk '{print $1}' /proc/loadavg)
# BusyBox-compatible uptime - read from /proc/uptime
uptime=$(awk '{days=int($1/86400); hours=int(($1%86400)/3600); mins=int(($1%3600)/60); if(days>0) printf "%dd %dh", days, hours; else if(hours>0) printf "%dh %dm", hours, mins; else printf "%dm", mins}' /proc/uptime)
tx_total=$(numfmt --to=iec < /sys/class/net/$interface/statistics/tx_bytes)
rx_total=$(numfmt --to=iec < /sys/class/net/$interface/statistics/rx_bytes)

# CPU calculation - need to sample twice to get accurate percentage
cpu_cache="/tmp/cpu_stats"
read user nice system idle iowait irq softirq < <(awk '/^cpu / {print $2,$3,$4,$5,$6,$7,$8}' /proc/stat)
cpu_now_total=$((user + nice + system + idle + iowait + irq + softirq))
cpu_now_idle=$idle

if [[ -f "$cpu_cache" ]]; then
    read cpu_prev_total cpu_prev_idle < "$cpu_cache"
    cpu_total_diff=$((cpu_now_total - cpu_prev_total))
    cpu_idle_diff=$((cpu_now_idle - cpu_prev_idle))

    if [[ $cpu_total_diff -gt 0 ]]; then
        cpu_use=$(awk "BEGIN {printf \"%.1f%%\", (($cpu_total_diff - $cpu_idle_diff) / $cpu_total_diff) * 100}")
    else
        cpu_use="0.0%"
    fi
else
    cpu_use="0.0%"
fi

echo "$cpu_now_total $cpu_now_idle" > "$cpu_cache"

# Battery status (only if laptop)
bat_status=""
if [[ -d /sys/class/power_supply/BAT0 ]] || [[ -d /sys/class/power_supply/BAT1 ]]; then
    bat_cap=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    bat_state=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)
    if [[ "$bat_state" == "Charging" ]]; then
        bat_status=" | BAT: ${bat_cap}%↑"
    else
        bat_status=" | BAT: ${bat_cap}%"
    fi
fi

echo "USR: $USER | UP: $uptime | DT: $dt | LOAD: $load_avg | PSC: $procs | RAM: $ram_use | CPU: $cpu_use | NET: ↑$tx_total ↓$rx_total${bat_status} "
