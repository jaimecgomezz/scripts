#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# handles heroku psql
#
# dependencies:
#   - heroku
####################### global
SHELL="${SHELL:-bash}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
APPLICATION="$1"
##############################

"$CONSOLE" -e "$SHELL" -c "heroku psql --app=$APPLICATION"
