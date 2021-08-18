#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# shows prefered top-like app
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
TOP="${TOP:-top}"
##############################

"$CONSOLE" -e "$SHELL" -c "$TOP"
