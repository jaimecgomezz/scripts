#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# post changes to the upstream
#
####################### global
DMENU=${DMENU:-dmenu}
####################### script
FILE_NAME="$( basename "$0")"
BASEDIR="$( readlink -f "$0" | sed "s|\/$FILE_NAME.*||g")"
##############################

get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg")"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

exec_action() {
  action="$1"

  eval "${BASEDIR}/actions/${action}.sh"
}

actions=(
  "open"
  "sync"
  "stash"
  "update"
  "prepare"
)
action="$( get_selection 'actions' "${actions[@]}")"

[ "$?" = 0 ] || exit 1

case "$action" in
  "open" | "sync" | "stash" | "update" | "prepare") exec_action "$action" ;;
  *) notify-send -u critical "Tasker" "Invalid action"                    ;;
esac
