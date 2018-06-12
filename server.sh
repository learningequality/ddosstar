#!/bin/bash

# ensure all interfaces are listening and will respond for the full range of IP addresses
for iface in $(ifconfig | cut -d ' ' -f1| tr '`:' '\n' | awk NF | grep -v -E "^lo$")
do
        for i in $(seq 1 255); do sudo ip address add 10.5.10.$i dev $iface; done
done

# start iperf in server mode, listening for incoming requests
iperf -s
