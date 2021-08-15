#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# shows man page as pdf
#
# dependencies:
#   - rofi
#   - zathura
######################### vars
LINES=10
MSG="man"
##############################

selection="$( man -k . | sort | awk '{print $1" "$2}' | rofi -dmenu -p $MSG -l $LINES )"

[ ! -z "$selection" ] || exit 1

echo "$selection" | awk '{print $1}' | xargs man -Tpdf | zathura -
