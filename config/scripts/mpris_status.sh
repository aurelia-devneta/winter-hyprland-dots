#!/bin/bash

# Player to be used
player="spotify"
max_length=24

# Temporary file to store the current scroll position
scroll_file="/tmp/mpris_scroll_position.txt"

# Initialize the scroll position if it doesn't exist
if [ ! -f $scroll_file ]; then
    echo "0" > $scroll_file
fi

# Function to format time from seconds to a readable format (MM:SS)
format_time() {
    local time_in_seconds=$1
    printf "%02d:%02d" $((time_in_seconds / 60)) $((time_in_seconds % 60))
}

# Fetching the song details
title=$(playerctl --player=$player metadata title)
artist=$(playerctl --player=$player metadata artist)
position=$(playerctl --player=$player position 2>/dev/null | cut -d. -f1)  # Treat as seconds directly
length=$(playerctl --player=$player metadata mpris:length 2>/dev/null | cut -d. -f1)  # Convert to integer

# Converting length from microseconds to seconds
length_in_seconds=$((length / 1000000))

# Check if the position and length are fetched correctly
if [ -z "$position" ] || [ -z "$length_in_seconds" ] || [ "$position" -eq 0 ] || [ "$length_in_seconds" -eq 0 ]; then
    echo "{\"text\": \"No track playing\", \"class\": \"stopped\"}"
    exit 0
fi

# Converting position and length to a more readable format
position_formatted=$(format_time $position)
length_formatted=$(format_time $length_in_seconds)

# Function to scroll text
scroll_text() {
    local text="$1"
    local max_length="$2"
    local scroll_position=$(cat $scroll_file)
    local part

    if [ ${#text} -le $max_length ]; then
        echo "{\"text\": \"$text\", \"class\": \"playing\"}"
        exit 0
    fi

    part="${text:scroll_position:max_length}"
    if [ ${#part} -lt $max_length ]; then
        part="${part} ${text:0:$((max_length - ${#part}))}"
    fi
    echo "{\"text\": \"$part\", \"class\": \"playing\"}"

    scroll_position=$(( (scroll_position + 1) % ${#text} ))
    echo "$scroll_position" > $scroll_file
}

# Check if title and artist are available
if [ -n "$title" ] && [ -n "$artist" ]; then
    combined="${title} - ${artist} (${position_formatted}/${length_formatted})"
elif [ -n "$title" ]; then
    combined="${title} (${position_formatted}/${length_formatted})"
else
    combined="No track playing"
fi

# Scroll the text and output in JSON format for Waybar
scroll_text "$combined" $max_length
