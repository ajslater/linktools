#!/bin/bash

if [[ $1 = '-r' ]]; then
  RECURSE=true
  shift;
fi

SOURCE=$1

IFS=$'\n'
for filename in *; do 
   if [[ -h "$filename" ]]; then
     ln -sf  "$SOURCE/$filename" .
   elif [[ $RECURSE && -d $filename ]]; then
     cd "$filename" || exit 1
     relink -r "$SOURCE/$filename"
     cd .. || exit 1
   fi
done;
