#!/usr/bin/env sh

##############################
# @jaimecgomezz
#
# exposes scripts contained
# in folder's subfolders
##############################

FILE_NAME="$( basename "$0" )"
EXPOSED_PATH="$( realpath "$0" | sed "s|$FILE_NAME||g" )"

cd "$EXPOSED_PATH"

cat /dev/null > .gitignore
find . -maxdepth 1 -type l -delete

for f in */*.sh ; do
  name="$( basename "$f" | sed 's/\.sh//' )"

  ln -s "${EXPOSED_PATH}${f}" "${EXPOSED_PATH}${name}"

  echo "$name" >> .gitignore
done
