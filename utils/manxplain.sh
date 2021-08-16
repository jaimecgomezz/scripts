#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# shows man page as pdf
#
# dependencies:
#   - rofi
#   - zathura
####################### global
DMENU="${DMENU:-dmenu}"
####################### script
LINES=10
MSG="man"
##############################

selection="$( man -k . | awk '{print $1" "$2}' | ${DMENU} -p $MSG -l $LINES )"

[ ! -z "$selection" ] || exit 1

echo "$selection" | awk '{print $1}' | xargs man -Tpdf | zathura -
