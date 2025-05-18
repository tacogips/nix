#!/usr/bin/env bash

# Get the mount point from the first argument
MOUNT="$1"

if [ -z "$MOUNT" ]; then
    echo '{"text": "Error", "tooltip": "No mount point specified"}'
    exit 1
fi

# Get disk usage information
DF_OUTPUT=$(df -h "$MOUNT" | awk 'NR==2 {print $3"/"$2, $5}')

# Parse the output
USAGE=$(echo "$DF_OUTPUT" | awk '{print $1}')
PERCENTAGE=$(echo "$DF_OUTPUT" | awk '{print $2}')

# Create a tooltip with more detailed information
TOOLTIP="Mount: $MOUNT\nUsage: $USAGE ($PERCENTAGE used)"

# Output JSON for waybar
echo "{\"text\": \"$USAGE\", \"tooltip\": \"$TOOLTIP\"}"