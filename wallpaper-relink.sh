#!/bin/sh
cd ~/Pictures/Wallpaper.Flat
rm -f *
flatlink.py ../Wallpaper -i '*.thumbnail*' -i .DS_Store
