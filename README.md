# linktools

Tools for creating and manipulating trees of symlinks.

## Install

From a checkout, install the tools as commands on your path:

```sh
uv tool install .
```

## Tools

### flatlink

Recursively walks a source directory and creates symbolic links of all those
files into one flat target directory.

### purgelink

Remove broken symlinks

### reflatlink

purgelink and then flatlink. I use this to make a macOS wallpaper directory from
a hierarchical pictures folder.

## Old

These others are old and could be made more efficient if I ever used them

### absolink

Recursively relinks relative symbolic links into absolute symbolic links.

### hierlink

Recursively replicates a directory tree but with hard or symbolically linked
files.
