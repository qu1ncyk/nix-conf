#!/bin/sh
swaymsg workspace 10

safeeyes &
wl-gammarelay-rs &
~/.config/sway/blue-filter &
syncthing --no-browser &
nm-applet --no-agent &
keepassxc &

sleep 1
swaymsg workspace 1
