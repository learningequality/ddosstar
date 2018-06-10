#!/bin/bash

source ./networksettings.sh

# connect to WLAN
IFS=$'\n'
for ad in $(iwconfig 2> /dev/null | grep REAL | grep -v -E "ESSID:\"$SSID\"" ); do
    unset IFS
    i=$(echo $ad | awk '{print $1;}');
    echo "Connecting interface $i to SSID \"$SSID\""
    # sudo nmcli dev disconnect $i
    # sleep 10
    sudo nmcli device wifi connect "$SSID" $PASSWORD ifname $i
done

# enable routing
IFS=$'\n'
incr=0
for ad in $(iwconfig 2> /dev/null | grep REAL | grep -E "ESSID:\"$SSID\"" ); do
    unset IFS
    i=$(echo $ad | awk '{print $1;}')
    incr=$((incr+1))
    ip=10.5.10.$incr
    echo "Setting routing for IP $ip"
    sudo ip route delete $ip 2> /dev/null
    sudo ip route add $ip via $HOSTIP dev $i
done

