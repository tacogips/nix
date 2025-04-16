#!/usr/bin/env bash

# Script to get CPU load data from CoolerControl API
# This script requires curl and jq

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987/api"

# Function to get CPU load
get_cpu_load() {
    # Try to get load data from CoolerControl API
    load_data=$(curl -s "${API_URL}/status/load")
    
    # If curl failed or returned empty data, fall back to system info
    if [ -z "$load_data" ] || [ "$load_data" == "{}" ]; then
        # Fallback to system load
        cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    else
        # Parse the CoolerControl API response
        cpu_load=$(echo "$load_data" | jq -r '.cpu_load // "N/A"')
    fi
    
    # Format the output
    if [ -n "$cpu_load" ] && [ "$cpu_load" != "N/A" ]; then
        # Round to integer
        cpu_load=$(printf "%.0f" "$cpu_load")
        echo "{ \"text\": \"$cpu_load%\", \"tooltip\": \"CPU Load: $cpu_load%\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Load data unavailable\" }"
    fi
}

get_cpu_load