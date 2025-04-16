#!/usr/bin/env bash

# Script to get CPU load data from CoolerControl API
# This script requires curl and jq

# Enable debug mode with DEBUG=1 environment variable
[[ -n "$DEBUG" ]] && set -x

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987/api"

# Get CPU load from system
get_load_from_system() {
    # Get CPU usage from top
    local load
    load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$load"
}

# Function to get CPU load
get_cpu_load() {
    # Try to get load data from CoolerControl API
    local load_data
    local api_available=false
    local cpu_load
    
    # Check if CoolerControl API is responsive
    if curl -s -f "${API_URL}/status" >/dev/null 2>&1; then
        api_available=true
        load_data=$(curl -s "${API_URL}/status/load")
        
        # Debug: log API response
        if [[ -n "$DEBUG" ]]; then
            echo "API Response: $load_data" >&2
        fi
    fi
    
    # If API is available and returned valid data
    if [ "$api_available" = true ] && [ -n "$load_data" ] && [ "$load_data" != "{}" ]; then
        # Check if the response is valid JSON
        if echo "$load_data" | jq . >/dev/null 2>&1; then
            # Try to get CPU load from API
            if echo "$load_data" | jq -e '.cpu_load' >/dev/null 2>&1; then
                cpu_load=$(echo "$load_data" | jq -r '.cpu_load // empty')
            fi
            
            # Try alternative API formats if needed
            if [ -z "$cpu_load" ] && echo "$load_data" | jq -e '.devices' >/dev/null 2>&1; then
                # Get the CPU load from the first device
                cpu_load=$(echo "$load_data" | jq -r '.devices[0].load // empty')
            fi
        fi
    fi
    
    # If we couldn't get load from API, fall back to system info
    if [ -z "$cpu_load" ]; then
        cpu_load=$(get_load_from_system)
    fi
    
    # Format the output
    if [ -n "$cpu_load" ]; then
        # Round to integer
        cpu_load=$(printf "%.0f" "$cpu_load" 2>/dev/null || echo "$cpu_load")
        echo "{ \"text\": \"$cpu_load%\", \"tooltip\": \"CPU Load: $cpu_load%\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Load data unavailable\" }"
    fi
}

get_cpu_load