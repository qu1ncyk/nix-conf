#!/bin/sh

safeeyes &
wl-gammarelay-rs run &
~/.config/sway/blue-filter &
syncthing --no-browser &
nm-applet --no-agent &
blueman-applet &
keepassxc &
thunderbird &

rm -f /tmp/ssh-agent.socket
eval `ssh-agent -a /tmp/ssh-agent.socket`
