#!/usr/bin/env bash

##############################
# @jaimecgomezz
#
# exposes scripts contained
# in folder's subfolders
####################### script
IGNORED=(
  "tags"
  "utils/hosts/*"
  "dcompose/workspaces"
)
FILE_NAME="$( basename "$0")"
EXPOSED_PATH="$( realpath "$0" | sed "s|$FILE_NAME||g")"
##############################

cat /dev/null >.gitignore
for i in "${IGNORED[@]}"; do
  echo "$i" >>.gitignore
done

cd "$EXPOSED_PATH" || exit 1

find . -maxdepth 1 -type l -delete

for f in */*.sh; do
  name="$( basename "$f" | sed 's/\.sh//')"

  ln -s "${EXPOSED_PATH}${f}" "${EXPOSED_PATH}${name}"

  echo "$name" >>.gitignore
done
