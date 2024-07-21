# winter-hyprland-dots
My personal dot files for Hyprland. Constantly a work in progress.

Current dependencies:\
Hyprland (duh)\
Waybar (Either waybar compiled with cava or waybar-cava on AUR)\
Cava\
mpris (For other media module if you do not want to use the custom module. Adjust waybar config accordingly)\
mpd (See mpris)\
sway (For swayng)\
Catppuccin cursors\
\
The waybar.sh script is an idea I am playing around with of having a module to reload waybar but don't really have a nead for.\
\
Change temperature sensor in the waybar config under the temperature module.\
\
You can get your sensor path with\
```for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done ```\
Credits to Jakoolit for the quick command.\
Typically amd CPUs are looking for k10temp and intel is looking for coretemp.
