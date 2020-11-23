#!/bin/bash
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyright (C) 2019 WildfootW All rights reserved.
#

power_info=$(upower --show-info /org/freedesktop/UPower/devices/battery_BAT0)
power_condition=$( echo "$power_info" | grep "state" | awk '
{
    if ($2 == "discharging")
        { print "Bat:" }
    else
        { print "AC:" }
}
')

if [ "$power_condition" == "Bat:" ]; then
    description=$( echo "$power_info" | grep "percentage" | awk '{ print $2 }')
    description="$( echo "$power_info" | grep "time to empty" | awk '{ print $4 " " $5 }') $description"

    echo "$power_condition $description"

elif [ "$power_condition" == "AC:" ]; then
    description=$( echo "$power_info" | grep "percentage" | awk '{ print $2 }')
    description="$( echo "$power_info" | grep "time to full" | awk '{ print $4 " " $5 }') $description"

    echo "$power_condition $description"

fi
