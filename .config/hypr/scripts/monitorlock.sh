#!/bin/bash

# Get the current position of the secondary monitor
current_pos=$(wlr-randr | grep "DP-2" | awk '{print $2}')

# Define the original and new positions
original_pos="-1920,360"
new_pos="-1920,1440"

# Check if the current position matches the original position
if [ "$current_pos" == "$original_pos" ]; then
    # If yes, move to the new position
    wlr-randr --output DP-2 --pos $new_pos
else
    # If not, move back to the original position
    wlr-randr --output DP-2 --pos $original_pos
fi

