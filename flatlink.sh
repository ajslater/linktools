#!/bin/bash
SRC_DIR="$1"
TARGET_DIR="$2"

usage() {
  echo "$0 <SOURCE_DIR> <TARGET_DIR>"
  echo
  echo "Recursively walks <SOURCE_DIR> and creates symbolic links of all those files into one flat directory, <TARGET_DIR>"
}

if [[ -z "$SRC_DIR" || -z "$TARGET_DIR" ]]; then
    usage
    exit 1
fi

find "$SRC_DIR" -type f -print0 | xargs -0 -I {} ln -sf {} "$TARGET_DIR"
