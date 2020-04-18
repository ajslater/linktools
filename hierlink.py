#!/usr/bin/env python3
"""Make a mirrored tree of directories with symlinks to the source files."""
import argparse
from pathlib import Path

__version__ = "0.1.1"


def get_options_and_arguments():
    """Parse command line arguments."""
    usage = "usage: %prog [options] <source directory>"
    parser = argparse.OptionParser(usage=usage)
    parser.add_option(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        default=1,
        help="Do not display output",
    )
    parser.add_option(
        "-s",
        "--symlink",
        action="store_true",
        dest="symlink",
        default=0,
        help="crease symbolic links intead of hard links",
    )
    parser.add_option(
        "-f",
        "--flatten",
        action="store_true",
        dest="flatten",
        default=0,
        help="Does not create a directory structure on the"
        "destination side, just a big flat collection of "
        "links to the source tree",
    )

    (options, arguments) = parser.parse_args()

    if len(arguments) <= 0:
        parser.print_help()
        exit(1)

    return (options, arguments)


def ln_file(source_path, dest_path, options):
    """Link the target file or creates a mirror directory."""
    if options.verbose:
        if options.symlink:
            pref = "Syml"
        else:
            pref = "L"

    print(f"{pref}inking {source_path}  to {dest_path}")

    if not dest_path.exists():
        dest_dir = dest_path.parent
        if not dest_dir.exists():
            if options.verbose:
                print(f"Creating {dest_dir} from {source_path}")
            dest_dir.mkdir()

        if options.symlink:
            source_path.symlink_to(dest_path)
        else:
            source_path.link_to(dest_path)


def process_dir(source_dir, dest_dir, options, relpath):
    """Traverse the source directory tree."""
    dest_dir = dest_dir.resolve()
    if not dest_dir.isdir():
        dest_dir.mkdir()

    for fn in sorted(source_dir.iterdir()):
        source_path = source_dir / fn
        dest_path = dest_dir / fn

        if source_path.isdir():
            if relpath and not options.flatten:
                newsource_dirname = dest_dir.parent / source_path
            else:
                newsource_dirname = source_path

            if options.flatten:
                newdest_dirname = dest_dir
            else:
                newdest_dirname = dest_path

            process_dir(newsource_dirname, newdest_dirname, options, relpath)
        else:
            ln_file(source_path, dest_path, options)


def main():
    """Parse arguments and start recursing."""
    (options, arguments) = get_options_and_arguments()

    if arguments:
        source_dir = Path(arguments[0]).resolve()
        relpath = Path(source_dir).resolve() != source_dir
    else:
        relpath = 0

    if options.verbose and relpath:
        print(f"Source directory {source_dir} is a relative path.")

        process_dir(source_dir, Path.cwd(), options, relpath)


if __name__ == "__main__":
    main()
