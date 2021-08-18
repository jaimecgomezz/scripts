#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# handles heroku console
####################### global
SHELL="${SHELL:-bash}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
APPLICATION="$1"
##############################

"${CONSOLE}" -e "${SHELL}" -c "heroku run console --app=$APPLICATION"
