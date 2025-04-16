#!/usr/bin/env bash

# Script to get temperature data from CoolerControl API
# This script requires curl and jq

# Enable debug mode with DEBUG=1 environment variable
[[ -n "$DEBUG" ]] && set -x

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987/api"

# Get temperature using lm_sensors
get_temp_from_sensors() {
    # Try different temperature formats
    local temp
    
    # Try Ryzen CPU temperature (Tctl)
    temp=$(sensors 2>/dev/null | grep -i "Tctl" | awk '{print $2}' | tr -d "+°C")
    
    # If that fails, try Intel CPU temperature
    if [ -z "$temp" ]; then
        temp=$(sensors 2>/dev/null | grep -i "Package id 0" | awk '{print $4}' | tr -d "+°C")
    fi
    
    # If that fails, try any Core temperature
    if [ -z "$temp" ]; then
        temp=$(sensors 2>/dev/null | grep -i "Core 0" | awk '{print $3}' | tr -d "+°C")
    fi
    
    echo "$temp"
}

# Function to get CPU temperature
get_cpu_temp() {
    # Try to get temperature data from CoolerControl API
    local temp_data
    local api_available=false
    local cpu_temp
    
    # Check if CoolerControl API is responsive
    if curl -s -f "${API_URL}/status" >/dev/null 2>&1; then
        api_available=true
        temp_data=$(curl -s "${API_URL}/status/temperature")
        
        # Debug: log API response
        if [[ -n "$DEBUG" ]]; then
            echo "API Response: $temp_data" >&2
        fi
    fi
    
    # If API is available and returned valid data
    if [ "$api_available" = true ] && [ -n "$temp_data" ] && [ "$temp_data" != "{}" ]; then
        # Check if the response is valid JSON
        if echo "$temp_data" | jq . >/dev/null 2>&1; then
            # Try to get CPU temperature from API
            if echo "$temp_data" | jq -e '.cpu_temperatures' >/dev/null 2>&1; then
                cpu_temp=$(echo "$temp_data" | jq -r '.cpu_temperatures[0] // empty')
            fi
            
            # If no CPU temp, try to get device temperatures
            if [ -z "$cpu_temp" ] && echo "$temp_data" | jq -e '.devices' >/dev/null 2>&1; then
                # Get the first temperature from any device
                cpu_temp=$(echo "$temp_data" | jq -r '.devices[0].temperatures[0].current // empty')
            fi
        fi
    fi
    
    # If we couldn't get temperature from API, fall back to sensors
    if [ -z "$cpu_temp" ]; then
        cpu_temp=$(get_temp_from_sensors)
    fi
    
    # Format the output
    if [ -n "$cpu_temp" ]; then
        # Round to one decimal place
        cpu_temp=$(printf "%.1f" "$cpu_temp" 2>/dev/null || echo "$cpu_temp")
        echo "{ \"text\": \"$cpu_temp°C\", \"tooltip\": \"CPU Temperature: $cpu_temp°C\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Temperature data unavailable\" }"
    fi
}

get_cpu_temp