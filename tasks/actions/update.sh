#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# post changes to the upstream
#
####################### global
FOLDER="${HOME}/repos/jaimecgomezz/tasks"
##############################

eval $(keychain --agents ssh --eval id_rsa)

notifys() { notify-send "Tasker" "$1"; }

notifyf() { notify-send -u critical "Tasker" "$1"; }

if cd "${FOLDER}"; then
  if git add -A && git commit -S -m "$( date)" && git push; then
    notifys "Updated"
  else
    notifyf "Update failed"
  fi
else
  notifyf "Missing task folder"
fi
