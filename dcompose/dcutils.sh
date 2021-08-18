#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# docker-compose utils entry
####################### global
DMENU=${DMENU:-dmenu}
####################### script
FILE_NAME="$( basename "$0")"
BASEDIR="$( readlink -f "$0" | sed "s|\/$FILE_NAME.*||g")"
DCFILE=docker-compose.yml
WORKSPACES=(
  "parvada@${HOME}/repos/aleph/parvada-web-api"
)
##############################

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

exec_action() {
  workspace="$1"
  shift
  action="$1"
  shift
  services_list=("$@")

  dcfile="$workspace/$DCFILE"

  eval "${BASEDIR}/actions/${action}.sh $dcfile ${services_list[*]}"
}

exec_action_on_services() {
  workspace="$1"
  action="$2"

  dcfile="$workspace/$DCFILE"

  services_opts="$(docker-compose --file "$dcfile" ps --services)"
  services="$( get_selection 'services' 1 "${services_opts[@]}")"

  [ "$?" = 0 ] || exit 1

  exec_action "$workspace" "$action" "${services[@]}"
}

workspaces="$( printf '%s\n' "${WORKSPACES[@]}" | sed 's/@.*//g')"
workspace="$( get_selection 'workspaces' 0 "${workspaces[@]}")"

[ "$?" = 0 ] || exit 1

workspace="$( printf '%s\n' "${WORKSPACES[@]}" | grep "^${workspace}@" | sed -E 's/^.*@//g')"

actions=(
  ps
  up
  logs
  stop
  restart
  build
)
action="$( get_selection 'actions' 0 "${actions[@]}")"

[ "$?" = 0 ] || exit 1

case "$action" in
  'ps')      exec_action "$workspace" 'ps'         ;;
  'build')   exec_action_on_services "$workspace" 'build'  ;;
  'logs')    exec_action_on_services "$workspace" 'logs'  ;;
  'restart') exec_action_on_services "$workspace" 'restart' ;;
  'stop')    exec_action_on_services "$workspace" 'stop'  ;;
  'up')      exec_action_on_services "$workspace" 'up'   ;;
esac
