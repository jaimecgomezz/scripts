#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# open task manager
#
####################### global
CONSOLE="${CONSOLE:-kitty}"
##############################

"$CONSOLE" -e taskwarrior-tui
