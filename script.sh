#!/bin/bash

echo "System monitor outline:"
echo "1. get the system usage values, stats etc."
echo "2. display on screen"
echo "3. clear screen"
echo "4. repeat these steps"


prev_cpu_value=""

while true; do
    clear

    echo "-------------------"
    echo "Bash system monitor"
    echo "-------------------"
    echo ""
    # this part is the CPU information (cpu stats etc.)
    echo "CPU STATS"
    top_output=$(top -bn1)
    cpu_line=$(echo "$top_output" | grep "%Cpu(s)")
    idle=$(echo "$cpu_line" | grep -oE "[0-9.]+ id" | grep -oE "[0-9.]+")

    # converting number to whole number by taking out ".".
    idle_cpu_value=${idle/./}
    # subtracting from 1000 to get value to be used as percentage
    raw_cpu_used_value=$((1000 - idle_cpu_value))
    cpu_used_value="$((raw_cpu_used_value / 10)).$((raw_cpu_used_value % 10))"
    #                        ^ whole number part      ^ point    ^ decimal part

    if [[ -z "$prev_cpu_value" ]]; then 
        arrow="-"
    elif [[ "$raw_cpu_used_value" -gt "$prev_cpu_value" ]]; then
        arrow="^"
    elif [[ "$raw_cpu_used_value" -lt "$prev_cpu_value" ]]; then
        arrow="v"
    else
        arrow="="
    fi

    echo "Used CPU percent: ${cpu_used_value} %  (${arrow})"

    prev_cpu_value=$raw_cpu_used_value

    ### End of cycle ###
    sleep 1

done