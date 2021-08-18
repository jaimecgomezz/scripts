#!/usr/bin/env bash

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
##############################

function get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg")"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

pages="$( man -k . | awk '{print $1" "$2}')"
page="$( get_selection 'man' "${pages[@]}")"

[ "$?" = 0 ] || exit 1

echo "$page" | awk '{print $1}' | xargs man -Tpdf | zathura -
