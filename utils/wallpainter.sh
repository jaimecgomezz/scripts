#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# sets wallpaper and re-runs
# itself until done
#
# it assumes that the user has
# a folder with wallpapers
# grouped by themes and looks
# into the one defined by
# $THEME
#
# once a theme is selected, it
# creates a symlink in the
# $WALLPAPERS folder named
# wallpaper, so it can be
# referenced by config files
#
####################### global
DMENU=${DMENU:-dmenu}
####################### script
THEME=nord
WALLPAPERS=~/pictures/walls
SELF="$( basename "$0" | sed 's/\.sh//g')"
##############################

PREVIOUS="$1"

get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg" -select "$PREVIOUS")"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

set_wallpaper() {
  ln -sf "$WALLPAPERS/$THEME/$1" "$WALLPAPERS/wallpaper"
  hsetroot -cover "$WALLPAPERS/wallpaper"
  notify-send "$SELF" "$1"
}

found="$(  ls -l "$WALLPAPERS/$THEME" | grep -e jpg -e png | awk '{print $9}')"
wallpapers=(done "${found[@]}")
wallpaper="$( get_selection 'wallpaper' "${wallpapers[@]}")"

[ "$?" = 0 ] || exit 1

case "$wallpaper" in
  "done") exit 0                ;;
  *) set_wallpaper "$wallpaper" ;;
esac

"$SELF" "$wallpaper"
