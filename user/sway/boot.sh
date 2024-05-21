#!/bin/sh
swaymsg workspace 10

safeeyes &
wl-gammarelay-rs run &
~/.config/sway/blue-filter &
syncthing --no-browser &
nm-applet --no-agent &
blueman-applet &
keepassxc &

sleep 1
swaymsg workspace 1
