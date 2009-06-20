#!/bin/sh

IFS=$'\n'
for i in `ls -Q1`; do 
   newpath=`readlink -nf $i`
   echo ln -sf $newpath $i
done
