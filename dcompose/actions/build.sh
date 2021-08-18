#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# handles docker-compose build
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
DCFILE="$1"
shift
SERVICES=("$@")
##############################

function notify_services() {
  success="$1"

  ((success)) && urgency="NORMAL" || urgency="CRITICAL"
  ((success)) && msg="built: ${SERVICES[*]}" || msg="failed: ${SERVICES[*]}"

  dunstify -a 'dcutils' -u "$urgency" "$msg"
}

function get_selection() {
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

function build_loudly() {
  options=("$@")

  "${CONSOLE}" -e "${SHELL}" -c "docker-compose --file $DCFILE build ${options[*]} ${SERVICES[*]}"
}

function build_quietly() {
  options=("$@")

  eval "docker-compose --file $DCFILE build ${options[*]} ${SERVICES[*]}"

  if [ "$?" = 0 ]; then
    notify_services 1
  else
    notify_services 0
  fi
}

options_opts=(
  --compress
  --force-rm
  --no-cache
  --no-rm
  --parallel
  --pull
)
options=("$( get_selection 'options' 1 "${options_opts[@]}")")

quietly_opts=(
  yes
  no
)
quietly="$( get_selection 'quiet?' 0 "${quietly_opts[@]}")"

[ "$?" = 0 ] || exit 1

case "$quietly" in
  'no')    build_loudly "${options[@]}"  ;;
  'yes')   build_quietly "${options[@]}" ;;
esac
