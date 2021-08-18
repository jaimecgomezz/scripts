#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# system exit management
####################### global
DMENU="${DMENU:-dmenu}"
####################### script
EXIT_MANAGER=i3exit
##############################

get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" -auto-select -matching normal)"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

actions=(
  lock
  suspend
  hibernate
  reboot
  Shutdown
  exit
)
action="$( get_selection 'actions' "${actions[@]}")"

[ "$?" = 0 ] || exit 1

case "$action" in
  'lock')       ${EXIT_MANAGER} 'lock'       ;;
  'suspend')    ${EXIT_MANAGER} 'suspend'    ;;
  'hibernate')  ${EXIT_MANAGER} 'hibernate'  ;;
  'reboot')     ${EXIT_MANAGER} 'reboot'     ;;
  'Shutdown')   ${EXIT_MANAGER} 'shutdown'   ;;
  'exit')       ${EXIT_MANAGER} 'logout'   ;;
esac
