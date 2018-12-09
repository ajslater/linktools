# linktools

Tools for creating and manipulating trees of symlinks

### flatlink
Recursively walks a source directory and creates symbolic links of all those files into one flat target directory.

### purgelink
Remove broken symlinks

### reflatlink
purgelink and then flatlink. I use this to make a macOS wallpaper directory
from a hierarcical pictures folder.

## Old
These others are old and could be made more efficient if I ever used them

### absolink
Recursively relinks relative symbolic links into absolute symbolic links.

### hierlink
Recursively replicates a directory tree but with symbolicly linked files.
