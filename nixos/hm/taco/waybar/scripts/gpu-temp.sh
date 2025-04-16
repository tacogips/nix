#!/usr/bin/env bash

# Script to get GPU temperature data from CoolerControl API
# This script requires curl and jq

# Enable debug mode with DEBUG=1 environment variable
[[ -n "$DEBUG" ]] && set -eux

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987/api"

# Function to get GPU temperature from Cooler Control API
get_gpu_temp() {
    # Get status data from CoolerControl API
    api_data=$(curl -s -X POST "${API_URL}/status" -H "Content-Type: application/json" -d '{}')

    # Debug: log API response
    if [[ -n "$DEBUG" ]]; then
        echo "API Response: $api_data" >&2
    fi

    local gpu_temp=""

    # Check if we got valid JSON
    if echo "$api_data" | jq . >/dev/null 2>&1; then
        # Get GPU temperature
        gpu_temp=$(echo "$api_data" | jq -r '.devices[] | select(.type=="GPU") | .status_history[0].temps[].temp' 2>/dev/null | sort -rn | head -1)
        
        # If no GPU temp found, try to find GPU temp from Hwmon devices
        if [ -z "$gpu_temp" ] || [ "$gpu_temp" == "null" ]; then
            # Try to find GPU from Hwmon devices
            gpu_temp=$(echo "$api_data" | jq -r '.devices[] | select(.name | contains("GPU") or contains("NVIDIA") or contains("AMD") or contains("Radeon")) | .status_history[0].temps[].temp' 2>/dev/null | sort -rn | head -1)
        fi
    fi

    # If we couldn't get temperature from API, fall back to nvidia-smi or other tools
    if [ -z "$gpu_temp" ] || [ "$gpu_temp" == "null" ]; then
        # Try nvidia-smi for NVIDIA GPUs
        if command -v nvidia-smi &> /dev/null; then
            gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader 2>/dev/null | head -1)
        # Try rocm-smi for AMD GPUs
        elif command -v rocm-smi &> /dev/null; then
            gpu_temp=$(rocm-smi --showtemp | grep -oP '\d+\.\d+' | head -1)
        fi
    fi

    # Format the output
    if [ -n "$gpu_temp" ] && [ "$gpu_temp" != "null" ]; then
        # Round to one decimal place
        gpu_temp=$(printf "%.1f" "$gpu_temp" 2>/dev/null || echo "$gpu_temp")
        echo "{ \"text\": \"$gpu_temp℃\", \"tooltip\": \"GPU Temperature: $gpu_temp℃\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"GPU Temperature data unavailable\" }"
    fi
}

get_gpu_temp