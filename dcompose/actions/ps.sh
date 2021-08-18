#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# handles docker-compose ps
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script

get_selection() {
  msg="$1"
  shift
  multi="$1"
  shift
  options=("$@")

  ((multi)) && multioptions="-multi-select"

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" "$multioptions")"

  echo "$selection" | paste -sd ' '

  [ -z "$selection" ] && return 1 || return 0
}

show() {
  statuz="$1"

  elements="$( docker ps --all --filter "status=$statuz" --format 'table{{.Image}}\t{{.Status}}' | tail +2)"

  elements="${elements:-None}"

  ( echo "${elements[@]}" | ${DMENU} -p 'ps' ) >/dev/null

  return "$?"
}

status_opts=(
  exited
  running
  created
  restarting
  removing
  paused
  dead
)
statuz="$( get_selection 'status' 0 "${status_opts[@]}")"

[ "$?" = 0 ] || exit 1

show "$statuz"
