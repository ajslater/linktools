#!/bin/sh
cd ~/Pictures/Wallpaper.Flat
rm -f *
flatlink ../Wallpaper -i '*.thumbnail*' -i .DS_Store
