#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# runs scripts located within
# the script folder
####################### global
DMENU="${DMENU:-dmenu}"
####################### script
SCRIPTS_PATH="$HOME/sh/"
##############################

function get_selection() {
  msg="$1"; shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" )"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

scripts="$( find "$SCRIPTS_PATH" -maxdepth 1 -type l -exec basename '{}' \; )"
script="$( get_selection 'run' "${scripts[@]}" )"

[ "$?" = 0 ] || exit 1

eval "$SCRIPTS_PATH/$script"
