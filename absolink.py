#!/usr/bin/env python3
"""Converts relative symlinks into absolute symlinks."""

__version__ = "0.1.2"

import argparse
from pathlib import Path


def get_options_and_arguments():
    """Return the options and the arguments."""
    usage = "usage: %prog [options]"
    parser = argparse.OptionParser(usage=usage)
    parser.add_option("path", action="store", default=Path.cwd()),
    parser.add_option(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        default=1,
        help="Don't give progress info",
    )
    parser.add_option(
        "-r",
        "--recursive",
        action="store_true",
        dest="recursive",
        default=0,
        help="Converts symbolic links to absolute symbolic" "links",
    )

    return parser.parse_args()


def relink_file(link_fn, options):
    """Convert the link."""
    target = Path(link_fn).resolve()
    link_fn.unlink()
    link_fn.symlink_to(target)
    if options.verbose:
        print(f"Relinked {link_fn} to {target}")


def process_dir(dn, options):
    """Find and descend into subdirectories."""
    for fn in Path(dn).iterdir():
        if fn.is_symlink():
            relink_file(fn, options)
        elif options.recursive and fn.is_dir():
            process_dir(fn, options)


def main():
    """Get options and recursivley link."""
    options, args = get_options_and_arguments()
    process_dir(options.path, options)


if __name__ == "__main__":
    main()
