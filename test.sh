#!/bin/bash

source ./networksettings.sh

# run speed tests
IFS=$'\n'
incr=0
printf "" > results.csv

for ad in $(iwconfig 2> /dev/null | grep REAL | grep -E "ESSID:\"$SSID\"" ); do
    unset IFS
    i=$(echo $ad | awk '{print $1;}')
    incr=$((incr+1))
    ip=10.5.10.$incr
    echo "Running iperf against IP $ip"
    iperf -c $ip -y C >> results.csv &
done

while [[ $(ps aux | grep "iperf -c 10.5.10" | grep -v grep | wc -l) != "0" ]]; do
    completed=$(cat results.csv | wc -l | awk '{print $1;}')
    echo "Completed $completed of $incr"
    sleep 1
done

total=0
incr=0
while IFS=',' read -r timestamp source_address source_port destination_address destination_port something interval transferred_bytes bits_per_second; do
    printf "%.2f Mbit on IP $destination_address\n" "$(bc -l <<< "$bits_per_second / 1000000")"
    # bits_per_second
    total=$((bits_per_second+total))
    incr=$((incr+1))
done < results.csv
printf "\n%.2f Mbit total, across $incr connections.\n" "$(bc -l <<< "$total / 1000000")"


