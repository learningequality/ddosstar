#!/bin/bash

source ./networksettings.sh

echo "Total number of wifi adapters attached and recognized by USB:"
lsusb | grep RTL8812AU | wc -l

echo "Total number of wifi adapters loaded and ready by iwconfig:"
iwconfig 2> /dev/null | grep REAL | wc -l

echo "Adapters connected to SSID '$SSID':"
iwconfig 2> /dev/null | grep REAL | grep -E "ESSID:\"$SSID\"" | wc -l
