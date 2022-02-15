#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# sets wallpaper and re-runs
# itself until done
#
####################### global
DMENU=${DMENU:-dmenu}
####################### script
WALLPAPERS=~/pictures/wallpapers
##############################

get_selection() {
  msg="$1"
  shift
  options=("$@")

  selection="$( printf '%s\n' "${options[@]}" | ${DMENU} -p "$msg")"

  echo "$selection"

  [ -z "$selection" ] && return 1 || return 0
}

set_wallpaper() {
  ln -sf "$WALLPAPERS/$1" "$WALLPAPERS/wallpaper"
  hsetroot -cover "$WALLPAPERS/wallpaper" wallpainter
}

found="$(  ls -l "$WALLPAPERS/" | grep -e jpg -e png | awk '{print $9}')"
wallpapers=(done "${found[@]}")
wallpaper="$( get_selection 'wallpaper' "${wallpapers[@]}")"

[ "$?" = 0 ] || exit 1

case "$wallpaper" in
  "done") exit 0                ;;
  *) set_wallpaper "$wallpaper" ;;
esac
