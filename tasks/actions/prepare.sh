#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# symlinks inner .task folder
# to ~/.task folder
#
####################### script
FOLDER="${HOME}/repos/jaimecgomezz/tasks"
##############################

if ln -vs "${FOLDER}/.task" "${HOME}/.task"; then
  notify-send "Tasker" "Linked"
else
  notify-send -u critical  "Tasker" "Error on symlink"
fi
