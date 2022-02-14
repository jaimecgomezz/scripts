#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# pull changes from the
# upstream
#
####################### script
FOLDER="${HOME}/repos/jaimecgomezz/tasks"
##############################

eval $(keychain --agents ssh --eval id_rsa)

notifys() { notify-send "Tasker" "$1"; }

notifyf() { notify-send -u critical "Tasker" "$1"; }

if cd "${FOLDER}"; then
  if [ -z "$(git diff)" ]; then
    if git pull origin; then
      notifys "Synced"
    else
      notifyf "Sync failed"
    fi
  else
    notifyf "Unstaged changes"
  fi
else
  notifyf "Missing task folder"
fi
