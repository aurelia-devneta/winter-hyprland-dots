#!/bin/bash

WALLPAPER_DIR=~/.config/hypr/wallpapers
INTERVAL=300 # Time interval in seconds

while true; do
  for wallpaper in "$WALLPAPER_DIR"/*; do
    swww img "$wallpaper"
    sleep $INTERVAL
  done
done
