# linktools

Tools for creating and manipulating trees of symlinks.

## Install

linktools needs Python 3.15. From a checkout, install the `linktools` command on
your path:

```sh
uv tool install .
```

## Usage

```sh
linktools COMMAND [-q] ...
```

`linktools -h` lists the commands and `linktools COMMAND -h` shows each one's
arguments. `-q` silences progress output.

### flat

`linktools flat SRC DEST` recursively walks SRC and creates symbolic links of
all its files, but dotfiles and dotdirs, in the flat directory DEST.

### purge

`linktools purge DEST` removes broken symlinks from DEST.

### reflat

`linktools reflat SRC DEST` purges and then flat links. I use this to make a
macOS wallpaper directory from a hierarchical pictures folder.

## Old

These others are old and could be made more efficient if I ever used them

### abs

`linktools abs [-r] [PATH]` relinks relative symbolic links in PATH, or the
current directory, into absolute symbolic links. `-r` descends into
subdirectories.

### hier

`linktools hier [-s] [-f] SRC [DEST]` replicates the SRC directory tree in DEST,
or the current directory, with hard linked files. `-s` makes symbolic links
instead and `-f` links every file into DEST without the tree.
