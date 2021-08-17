#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# handles heroku logs
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmenu}"
CONSOLE="${CONSOLE:-kitty}"
####################### script
APPLICATION="$1"
##############################

function get_selection() {
  msg="$1"; shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" )"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

function logs() {
  rest="$@"

  ((FOLLOW)) && follow='-t'
  ((!FOLLOW)) && holder='sh'

  ${CONSOLE} -e ${SHELL} -c "heroku logs $follow --app=$APPLICATION $rest ; $holder"
}

function dynologs() {
  dynos="$( heroku ps "--app=$APPLICATION" | grep "===" | awk '{print $2}' )"
  dyno="$( get_selection 'dynos' "${dynos[@]}" )"

  logs "--dyno=$dyno"
}

options=(
  follow
  print
)
option="$( get_selection 'options' "${options[@]}" )"

case "$option" in
  'follow') FOLLOW=1;;
  'print' ) FOLLOW=0;;
esac

options=(
  all
  specific
)
option="$( get_selection 'dynos' "${options[@]}" )"

[ "$?" = 0 ] || exit 1

case "$option" in
  'all'     ) logs      ;;
  'specific') dynologs  ;;
esac
