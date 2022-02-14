#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# stash local task changes to
# pull from upstream
#
####################### global
FOLDER="${HOME}/repos/jaimecgomezz/tasks"
##############################

if cd "${FOLDER}"; then
  if git stash --include-untracked; then
    notify-send "Tasker" "Stashed"
  fi
else
  notify-send -u critical "Tasker" "Missing task folder"
fi
