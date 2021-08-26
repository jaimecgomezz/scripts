#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# opens default reader
####################### global
SHELL="${SHELL:-bash}"
CONSOLE="${CONSOLE:-kitty}"
READER="${READER:-newsboat}"
##############################

"$CONSOLE" -e "$SHELL" -c "$READER"
