#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# handles docker-compose up
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
DCFILE="$1"; shift
SERVICES="$@"
##############################

function notify_services() {
  success="$1"

  ((success)) && urgency="NORMAL" || urgency="CRITICAL"
  ((success)) && msg="up: ${SERVICES[@]}" || msg="failed: ${SERVICES[@]}"

  dunstify -a 'dcutils' -u "$urgency" "$msg"
}

function get_selection() {
  msg="$1"; shift
  multi="$1"; shift
  options=("$@")

	((multi)) && multioptions="-multi-select"

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" "$multioptions" )"

	echo "$( echo "$selection" | paste -sd ' ' )"

  [ -z "$selection" ] && return 1 || return 0
}

function up_loudly() {
  options="$@"

  ${CONSOLE} -e ${SHELL} -c "docker-compose --file $DCFILE up $options ${SERVICES[@]}"
}

function up_quietly() {
  options="$@"

  eval "docker-compose --file $DCFILE up -d $options ${SERVICES[@]}"

  [ "$?" = 0 ] && notify_services 1 || notify_services 0
}

options=(
  --no-color
  --quiet-pull
  --no-deps
  --force-recreate
  --always-recreate-deps
  --no-recreate
  --no-build
  --no-start
  --build
  --abort-on-container-exit
  --remove-orphans
  --no-log-prefix
)
options="$( get_selection 'options' 1 "${options[@]}" )"

quietly_opts=(
  yes
  no
)
quietly="$( get_selection 'quiet?' 0 "${quietly_opts[@]}" )"

[ "$?" = 0 ] || exit 1

case "$quietly" in
  'no'  )  up_loudly "$options"  ;;
  'yes' )  up_quietly "$options" ;;
esac
