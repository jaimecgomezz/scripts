#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# allows to run commands with
# sudo privileges
##############################

# grant agent is running
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 2>/dev/null &

pkexec sh -c "$@"

exit "$?"
