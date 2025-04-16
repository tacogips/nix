#!/usr/bin/env bash

# Script to get CPU load data from CoolerControl API
# This script requires curl and jq

# Enable debug mode with DEBUG=1 environment variable
[[ -n "$DEBUG" ]] && set -x

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987"

# Function to get CPU load from Cooler Control API
get_cpu_load() {
    # Get status data from CoolerControl API
    api_data=$(curl -s -X POST "${API_URL}/status" -H "Content-Type: application/json" -d '{}')

    # Debug: log API response
    if [[ -n "$DEBUG" ]]; then
        echo "API Response: $api_data" >&2
    fi

    # Check if we got valid JSON
    if echo "$api_data" | jq . >/dev/null 2>&1; then
        # Try to get CPU load from CPU device channel named 'CPU Load'
        cpu_load=$(echo "$api_data" | jq -r '.devices[] | select(.type=="CPU") | .status_history[0].channels[] | select(.name=="CPU Load") | .duty' 2>/dev/null)

        # If no CPU load found, try to get GPU load as fallback
        if [ -z "$cpu_load" ] || [ "$cpu_load" == "null" ]; then
            cpu_load=$(echo "$api_data" | jq -r '.devices[] | select(.type=="GPU") | .status_history[0].channels[] | select(.name=="GPU Load") | .duty' 2>/dev/null)
        fi
    fi

    # If we couldn't get load from API, fall back to system info
    if [ -z "$cpu_load" ] || [ "$cpu_load" == "null" ]; then
        # Fallback to system load using top
        cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    fi

    # Format the output
    if [ -n "$cpu_load" ] && [ "$cpu_load" != "null" ]; then
        # Round to integer
        cpu_load=$(printf "%.0f" "$cpu_load" 2>/dev/null || echo "$cpu_load")
        echo "{ \"text\": \"$cpu_load%\", \"tooltip\": \"CPU Load: $cpu_load%\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Load data unavailable\" }"
    fi
}

get_cpu_load
