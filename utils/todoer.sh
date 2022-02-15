#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# simple todo list to quickly
# add/remove tasks that can
# be later migrated to an
# specialized task manager
#
####################### global
SHELL="${SHELL:-bash}"
DMENU="${DMENU:-dmemu}"
CONSOLE="${CONSOLE:-kitty}"
NOTIFIER="${NOTIFIER:-dunstify}"
####################### script
TASKS_FILE="$HOME/tasks"
##############################

send_notification() {
  success="$1"
  msg="$2"

  ((success)) && urgency="NORMAL" || urgency="CRITICAL"

  "$NOTIFIER" 'todoer' -u "$urgency" "$msg"
}

create_tasks_file() { touch "$TASKS_FILE"; }

[ -e "$TASKS_FILE" ] || create_tasks_file

selection="$( ${DMENU} -p 'tasks' '-multi-select' <"$TASKS_FILE")"

if grep "^${selection}$" <"$TASKS_FILE"; then
  for e in $selection; do
      sed -i "\|${e}|d" "$TASKS_FILE"
  done
else
  echo "$selection" >>"$TASKS_FILE"
fi

sed -i -e '/^$/d' -e '/^ *$/d' "$TASKS_FILE"
