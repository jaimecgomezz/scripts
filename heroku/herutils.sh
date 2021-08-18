#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# heroky utils entry
#
# dependencies:
#   - heroku
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
  application="$2"

  eval "${BASEDIR}/actions/${action}.sh $application"
}

actions=(
  logs
  console
)
action="$( get_selection 'actions' "${actions[@]}")"

[ "$?" = 0 ] || exit 1

applications="$( heroku apps -A | sed -e '1d' -e '$d')"
application="$( get_selection 'application' "${applications[@]}")"

[ "$?" = 0 ] || exit 1

case "$action" in
  'logs')     exec_action 'logs' "$application"    ;;
  'console')  exec_action 'console' "$application" ;;
esac
