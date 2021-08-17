#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# handles docker-compose logs
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
DCFILE="$1"; shift
SERVICES="$@"
##############################

function get_selection() {
  msg="$1"; shift
  multi="$1"; shift
  options=("$@")

	((multi)) && multioptions="-multi-select"

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" "$multioptions" )"

	echo "$( echo "$selection" | paste -sd ' ' )"

  [ -z "$selection" ] && return 1 || return 0
}

function logs() {
  options="$@"

  ((FOLLOW)) && follow='-f'
  ((!FOLLOW)) && holder="sh"

  ${CONSOLE} -e ${SHELL} -c "docker-compose --file $DCFILE logs $follow $options ${SERVICES[@]} ; $holder"
}

options=(
  --no-color
  --timestamps
  --no-log-profix
)
options="$( get_selection 'options' 1 "${options[@]}" )"

follow_opts=(
  yes
  no
)
should_follow="$( get_selection 'follow?' 0 "${follow_opts[@]}" )"

[ "$?" = 0 ] || exit 1

case "$should_follow" in
  'yes' ) FOLLOW=1  ;;
  'no'  ) FOLLOW=0  ;;
esac

logs "$options"
