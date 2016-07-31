#!/bin/bash
IFS=$'\n'
SRC_DIR="$1"
TARGET_DIR="$2"

usage() {
  echo "$0 <SOURCE_DIR> <TARGET_DIR>"
  echo
  echo "Recursively walks <SOURCE_DIR> and creates symbolic links of all those files into one flat directory, <TARGET_DIR>"
}

function link_if_new() {
  src_path=$(realpath "$1")
  src_fn="${src_path##*/}"
  dst_path="$TARGET_DIR"/"$src_fn"
  if [[ ! -e "$dst_path" || "$src_path" != $(realpath "$dst_path") ]]; then
    echo ln -sf "$src_path" "$TARGET_DIR"/
    ln -sf "$src_path" "$TARGET_DIR"
  else
    echo -n .
  fi
}

function linkem() {
  src_dir=$1
  for fn in $src_dir/*; do
    if [[ -d "$fn" ]]; then
      linkem "$fn"
    else
      link_if_new "$fn"
    fi
  done
}

if [[ -z "$1" || -z "$2" ]]; then
    usage
    exit 1
fi

linkem "$SRC_DIR"
