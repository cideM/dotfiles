#!/usr/bin/env sh

# https://github.com/jonhoo/configs/blob/master/gui/.config/polybar/launch.sh
killall -q polybar

# Wait until processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

exec polybar --reload main
