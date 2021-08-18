#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# handles docker-compose stop
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
DCFILE="$1"
shift
SERVICES=("$@")
##############################

notify_services() {
  success="$1"

  ((success)) && urgency="NORMAL" || urgency="CRITICAL"
  ((success)) && msg="stopped: ${SERVICES[*]}" || msg="failed: ${SERVICES[*]}"

  dunstify -a 'dcutils' -u "$urgency" "$msg"
}

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

stop_loudly() {
  options=("$@")

  "${CONSOLE}" -e "${SHELL}" -c "docker-compose --file $DCFILE stop ${options[*]} ${SERVICES[*]} || $SHELL"
}

stop_quietly() {
  options=("$@")

  eval "docker-compose --file $DCFILE stop ${options[*]} ${SERVICES[*]}"

  if [ "$?" = 0 ]; then
    notify_services 1
  else
    notify_services 0
  fi
}

quietly_opts=(
  yes
  no
)
quietly="$( get_selection 'quiet?' 0 "${quietly_opts[@]}")"

[ "$?" = 0 ] || exit 1

case "$quietly" in
  'no')    stop_loudly "${options[@]}"  ;;
  'yes')   stop_quietly "${options[@]}" ;;
esac
