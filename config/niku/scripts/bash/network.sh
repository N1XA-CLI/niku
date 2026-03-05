#!/bin/bash

wifi_status=$(nmcli -t -f TYPE,STATE device 2>/dev/null | grep "^wifi:" | cut -d: -f2)
[ "$wifi_status" = "connected" ] && wifi=" " || wifi="󰖪"

bt="󰂲" 

devices=$(echo -e 'devices\nquit' | bluetoothctl 2>/dev/null | grep "^Device" | awk '{print $2}')

for mac in $devices; do
    if echo -e "info $mac\nquit" | bluetoothctl 2>/dev/null | grep -q "Connected: yes"; then
        bt="󰂱" 
        break
    fi
done

echo "$wifi $bt"
