#!/bin/bash
IFS=$'\n'
SRC_DIR="$1"
TARGET_DIR="$2"

function link_if_new() {
  src_path=$(realpath "$1")
  src_fn=$(basename "$src_path")
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

linkem "$SRC_DIR"
