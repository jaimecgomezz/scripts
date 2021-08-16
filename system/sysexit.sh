#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# system exit management
####################### global
DMENU="${DMENU:-dmenu}"
####################### script
EXIT_MANAGER=i3exit
##############################

function get_selection() {
  msg="$1"; shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" -auto-select -filter '[' -matching normal )"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

actions=('[l]ock' '[s]uspend' '[h]ibernate' '[r]eboot' '[S]hutdown')
action="$( get_selection 'actions' "${actions[@]}" )"

[ "$?" = 0 ] || exit 1

case "$action" in
  '[l]ock'      ) ${EXIT_MANAGER} 'lock'       ;;
  '[s]uspend'   ) ${EXIT_MANAGER} 'suspend'    ;;
  '[h]ibernate' ) ${EXIT_MANAGER} 'hibernate'  ;;
  '[r]eboot'    ) ${EXIT_MANAGER} 'reboot'     ;;
  '[S]hutdown'  ) ${EXIT_MANAGER} 'shutdown'   ;;
esac
