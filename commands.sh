#!/bin/bash

swww img $1 -t grow --transition-duration 1
echo "Wallpaper being used is $1"
echo "$2"
wallust run $1
cp $1 ~/Pictures/wallpaper.png
if [[ "$1" != *_themed* ]]; then
    cp $1 ~/Pictures/wallpaper_def.png
fi
# swww img ~/Pictures/wallpaper.png -t grow --transition-duration 1
killall -SIGUSR2 waybar 
swaync-client -rs
notify-send -i color "Changing wallpaper and colorscheme" "Waypaper at work" -a "Waypaper"
# killall quickshell
cp ~/.cache/temp/Colours.qml ~/.config/quickshell/popout/services/Colours.qml
rm ~/.cache/temp/Colours.qml
# quickshell -c popout
# quickshell -c sidebar -n
pywalfox update
killall swayosd-server
if pgrep -x "spotify" > /dev/null; then
    spicetify apply
fi

sleep 0.5
# quickshell -c sidebar
swayosd-server
# quickshell -c sidebar

