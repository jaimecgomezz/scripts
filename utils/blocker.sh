#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# enables content-blockers
# defined within the `hosts`
# folder
####################### global
DMENU=${DMENU:-dmenu}
NOTIFIER="${NOTIFIER:-dunstify}"
####################### script
FILE_NAME="$( basename "$0")"
BASEDIR="$( readlink "$0" | sed "s|\/$FILE_NAME.*||g")"
BASE_HOSTS=base
HOSTS_DIR="$BASEDIR/hosts"
##############################

notify_result() {
  success="$1"
  msg="$2"

  ((success)) && urgency="NORMAL" || urgency="CRITICAL"

  "$NOTIFIER" -a 'blocker' -u "$urgency" "$msg"
}

get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg")"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

activate_blocker() {
  blokers="$( ls "$HOSTS_DIR" | grep -v "$BASE_HOSTS")"
  bloker="$( get_selection "blocker" "${blokers[@]}")"

  [ "$?" = 0 ] || exit 1

  suexec "cat $HOSTS_DIR/$BASE_HOSTS $HOSTS_DIR/$bloker > /etc/hosts"

  if [ "$?" = 0 ]; then
    notify_result 1 "$bloker"
  else
    notify_result 0 "$bloker"
  fi
}

deactivate_blokers() {
  suexec "cat $HOSTS_DIR/$BASE_HOSTS > /etc/hosts"

  if [ "$?" = 0 ]; then
    notify_result 1 "deactivated"
  else
    notify_result 0 "deactivated"
  fi
}

actions=(
  activate
  deactivate
)
action="$( get_selection "actions" "${actions[@]}")"

[ "$?" = 0 ] || exit 1

case "$action" in
  activate) activate_blocker      ;;
  deactivate) deactivate_blokers  ;;
esac
