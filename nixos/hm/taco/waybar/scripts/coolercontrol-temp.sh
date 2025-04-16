#!/usr/bin/env bash

# Script to get temperature data from CoolerControl API
# This script requires curl and jq

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987/api"

# Function to get CPU temperature
get_cpu_temp() {
    # Try to get temperature data from CoolerControl API
    temp_data=$(curl -s "${API_URL}/status/temperature")
    
    # If curl failed or returned empty data, fall back to lm_sensors
    if [ -z "$temp_data" ] || [ "$temp_data" == "{}" ]; then
        # Fallback to sensors command
        cpu_temp=$(sensors | grep -i "Tctl" | awk '{print $2}' | tr -d "+°C")
        if [ -z "$cpu_temp" ]; then
            # Try alternative sensor format
            cpu_temp=$(sensors | grep -i "Package id 0" | awk '{print $4}' | tr -d "+°C")
        fi
    else
        # Parse the CoolerControl API response
        cpu_temp=$(echo "$temp_data" | jq -r '.cpu_temperatures[0] // "N/A"')
        if [ "$cpu_temp" == "null" ] || [ "$cpu_temp" == "N/A" ]; then
            # Try to get the first available temperature
            cpu_temp=$(echo "$temp_data" | jq -r 'if .temperatures then .temperatures[0] else "N/A" end')
        fi
    fi
    
    # Format the output
    if [ -n "$cpu_temp" ] && [ "$cpu_temp" != "N/A" ]; then
        echo "{ \"text\": \"$cpu_temp°C\", \"tooltip\": \"CPU Temperature: $cpu_temp°C\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Temperature data unavailable\" }"
    fi
}

get_cpu_temp