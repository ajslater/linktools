#!/bin/sh
# Remove all broken links from listed glob targetsa
set -o nounset
set -o errexit

for fn in "$@"; do
    if [ ! -e "$fn" ]; then
        echo rm "$fn"
        rm "$fn"
    fi
done
