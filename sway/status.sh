#!/bin/sh
# POSIX sh status bar. No bashisms, no GNU coreutils deps.
# Long-running: shell starts once, ticks internally every 1s.
# Per-tick: 0 child processes (except `sleep`), 0 fs writes outside /proc reads.

set -u  # treat unset vars as errors. All state is explicitly initialized below.

# IEC formatter, one decimal place. Input: bytes.
# Out-param via `_iec_buf` (avoids $() subshell fork). Caller: `fmt_iec N; var=$_iec_buf`.
_iec_buf=
fmt_iec() {
    local n=$1
    if [ "$n" -ge 1073741824 ]; then
        _iec_buf="$((n / 1073741824)).$(( (n * 10 / 1073741824) % 10 ))G"
    elif [ "$n" -ge 1048576 ]; then
        _iec_buf="$((n / 1048576)).$(( (n * 10 / 1048576) % 10 ))M"
    elif [ "$n" -ge 1024 ]; then
        _iec_buf="$((n / 1024)).$(( (n * 10 / 1024) % 10 ))K"
    else
        _iec_buf="${n}B"
    fi
}

# Tick rates based on kernel spec in seconds
IFACE_REFRESH=30
LOAD_REFRESH=5
UPTIME_REFRESH=60

# Cross-tick state 
cpu_prev_total=
cpu_prev_idle=
notified_10=
notified_20=
interface=
net_type=
iface_ttl=0     # re-detect interface every IFACE_REFRESH ticks
load_ttl=0      # re-read /proc/loadavg every LOAD_REFRESH ticks (kernel updates 1m-avg every 5s)
uptime_ttl=0    # re-read /proc/uptime every UPTIME_REFRESH ticks (display rounds to minutes)
load_avg=
uptime=

# RAM total: doesn't change at runtime, format once
read -r _ mem_total_kb _ < /proc/meminfo  # MemTotal: is line 1
fmt_iec $((mem_total_kb * 1024)); mem_total_h=$_iec_buf

while :; do
    # Interface detection: cache for IFACE_REFRESH ticks. Re-detect if cached
    # interface's stats file vanished (cable yanked, wifi dropped) or TTL expired.
    if [ "$iface_ttl" -le 0 ] || [ ! -r "/sys/class/net/$interface/statistics/tx_bytes" ]; then
        interface=
        while read -r iface dest _; do
            if [ "$dest" = "00000000" ]; then
                interface=$iface
                break
            fi
        done < /proc/net/route
        if [ -d "/sys/class/net/$interface/wireless" ]; then
            net_type="WiFi"
        else
            net_type="ETH"
        fi
        iface_ttl=$IFACE_REFRESH
    fi
    iface_ttl=$((iface_ttl - 1))

    # Process count via glob
    set -- /proc/[0-9]*
    procs=$#

    # RAM used = total - available (modern `free` semantics).
    # Break after MemAvailable found (line 3 of /proc/meminfo) to skip ~45 read calls.
    mem_avail_kb=0
    while read -r k v _; do
        if [ "$k" = "MemAvailable:" ]; then
            mem_avail_kb=$v
            break
        fi
    done < /proc/meminfo
    mem_used_kb=$((mem_total_kb - mem_avail_kb))
    fmt_iec $((mem_used_kb * 1024)); mem_used_h=$_iec_buf
    ram_use="$mem_used_h/$mem_total_h"

    # Load avg: refresh every LOAD_REFRESH ticks (kernel only updates the 1m avg every 5s)
    if [ "$load_ttl" -le 0 ]; then
        read -r load_avg _ < /proc/loadavg
        load_ttl=$LOAD_REFRESH
    fi
    load_ttl=$((load_ttl - 1))

    # Uptime: refresh every UPTIME_REFRESH ticks (display only changes when minutes tick over)
    if [ "$uptime_ttl" -le 0 ]; then
        read -r up _ < /proc/uptime
        up=${up%.*}
        days=$((up / 86400))
        hours=$(( (up % 86400) / 3600 ))
        mins=$(( (up % 3600) / 60 ))
        if [ "$days" -gt 0 ]; then
            uptime="${days}d ${hours}h"
        elif [ "$hours" -gt 0 ]; then
            uptime="${hours}h ${mins}m"
        else
            uptime="${mins}m"
        fi
        uptime_ttl=$UPTIME_REFRESH
    fi
    uptime_ttl=$((uptime_ttl - 1))

    # Net bytes
    read -r tx_raw < "/sys/class/net/$interface/statistics/tx_bytes"
    read -r rx_raw < "/sys/class/net/$interface/statistics/rx_bytes"
    fmt_iec "$tx_raw"; tx_total=$_iec_buf
    fmt_iec "$rx_raw"; rx_total=$_iec_buf

    # CPU: aggregate /proc/stat line, diff against prior tick's snapshot
    read -r _ u ni sy id io ir si _ < /proc/stat
    cpu_now_total=$((u + ni + sy + id + io + ir + si))
    cpu_now_idle=$id
    cpu_use="0.0%"
    if [ -n "$cpu_prev_total" ]; then
        td=$((cpu_now_total - cpu_prev_total))
        idl=$((cpu_now_idle - cpu_prev_idle))
        if [ "$td" -gt 0 ]; then
            p=$(( (td - idl) * 1000 / td ))
            cpu_use="$((p / 10)).$((p % 10))%"
        fi
    fi
    cpu_prev_total=$cpu_now_total
    cpu_prev_idle=$cpu_now_idle

    # Battery: iterate any BAT*/capacity, read first hit
    bat_status=
    bat_cap=
    bat_state=
    for f in /sys/class/power_supply/BAT*/capacity; do
        [ -r "$f" ] || continue
        read -r bat_cap < "$f"
        sf="${f%/capacity}/status"
        [ -r "$sf" ] && read -r bat_state < "$sf"
        break
    done
    if [ -n "$bat_cap" ]; then
        if [ "$bat_state" = "Charging" ]; then
            bat_status=" | BAT: ${bat_cap}%↑"
            notified_10=
            notified_20=
        else
            bat_status=" | BAT: ${bat_cap}%↓"
            if [ "$bat_cap" -le 10 ] && [ -z "$notified_10" ]; then
                swaymsg exec "notify-send -u critical 'Battery Critical' '${bat_cap}% - plug in now!'"
                notified_10=1
            elif [ "$bat_cap" -le 20 ] && [ -z "$notified_20" ]; then
                swaymsg exec "notify-send -u normal 'Battery Low' '${bat_cap}% remaining'"
                notified_20=1
            fi
        fi
    fi

    echo "USR: $USER | UP: $uptime | LOAD: $load_avg | PSC: $procs | RAM: $ram_use | CPU: $cpu_use | NET($net_type): ↑$tx_total ↓$rx_total${bat_status} "
    sleep 1
done
