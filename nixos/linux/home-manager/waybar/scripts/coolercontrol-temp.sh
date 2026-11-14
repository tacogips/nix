#!/usr/bin/env bash


# Script to get highest CPU temperature data from CoolerControl API
# This script requires curl and jq

# Enable debug mode with DEBUG=1 environment variable
[[ -n "$DEBUG" ]] && set -eux

# CoolerControl API URL (default port is 11987)
API_URL="http://localhost:11987"

# Function to get highest CPU temperature from Cooler Control API
get_highest_cpu_temp() {
    # Get status data from CoolerControl API
    api_data=$(curl -s -X POST "${API_URL}/status" -H "Content-Type: application/json" -d '{}')

    # Debug: log API response
    if [[ -n "$DEBUG" ]]; then
        echo "API Response: $api_data" >&2
    fi

    local cpu_temp=""
    # Check if we got valid JSON
    if echo "$api_data" | jq . >/dev/null 2>&1; then
        # Get all CPU temperatures and find the highest
        cpu_temp=$(echo "$api_data" | jq -r '.devices[] | select(.type=="CPU") | .status_history[0].temps[].temp' 2>/dev/null | sort -rn | head -1)


        # If no CPU temp found, try Hwmon devices
        if [ -z "$cpu_temp" ] || [ "$cpu_temp" == "null" ]; then
            # Get all temperatures from Hwmon devices in range 25-95°C (likely CPU temps)
            cpu_temp=$(echo "$api_data" | jq -r '.devices[] | select(.type=="Hwmon") | .status_history[0].temps[] | select(.temp > 25 and .temp < 95) | .temp' 2>/dev/null | sort -rn | head -1)
        fi
    fi

    # If we couldn't get temperature from API, fall back to sensors
    if [ -z "$cpu_temp" ] || [ "$cpu_temp" == "null" ]; then
        # Get all CPU temperatures from sensors and find the highest
        cpu_temp=$(sensors 2>/dev/null | grep -E 'Core|Tctl|Package id' | awk '{print $2}' | tr -d "+u00b0C" | tr -d ":" | sort -rn | head -1)

    fi

    # Format the output
    if [ -n "$cpu_temp" ] && [ "$cpu_temp" != "null" ]; then
        # Round to one decimal place
        cpu_temp=$(printf "%.1f" "$cpu_temp" 2>/dev/null || echo "$cpu_temp")
        echo "{ \"text\": \"$cpu_temp℃\", \"tooltip\": \"CPU Max Temperature: $cpu_temp\" }"
    else
        echo "{ \"text\": \"N/A\", \"tooltip\": \"CPU Temperature data unavailable\" }"
    fi
}

get_highest_cpu_temp
