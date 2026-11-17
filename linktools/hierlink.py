"""Make a mirrored tree of directories with links to the source files."""

from argparse import ArgumentParser, Namespace
from pathlib import Path

__version__ = "0.1.1"


def get_arguments() -> Namespace:
    """Parse command line arguments."""
    parser = ArgumentParser(
        description=f"{__doc__} The tree is made in the current directory."
    )
    parser.add_argument("source", type=Path, help="Source directory")
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        help="Do not display output",
    )
    parser.add_argument(
        "-s",
        "--symlink",
        action="store_true",
        help="Create symbolic links instead of hard links",
    )
    parser.add_argument(
        "-f",
        "--flatten",
        action="store_true",
        help="Do not create a directory structure on the destination side, just a big flat collection of links to the source tree",
    )
    return parser.parse_args()


def ln_file(source_path: Path, dest_path: Path, options: Namespace) -> None:
    """Link the target file."""
    if dest_path.exists() or dest_path.is_symlink():
        return

    if options.verbose:
        pref = "Syml" if options.symlink else "L"
        print(f"{pref}inking {source_path} to {dest_path}")

    if options.symlink:
        dest_path.symlink_to(source_path)
    else:
        dest_path.hardlink_to(source_path)


def process_dir(source_dir: Path, dest_dir: Path, options: Namespace) -> None:
    """Traverse the source directory tree, creating mirror directories."""
    if not dest_dir.is_dir():
        if options.verbose:
            print(f"Creating {dest_dir} from {source_dir}")
        dest_dir.mkdir()

    for source_path in sorted(source_dir.iterdir()):
        dest_path = dest_dir / source_path.name
        if source_path.is_dir():
            new_dest_dir = dest_dir if options.flatten else dest_path
            process_dir(source_path, new_dest_dir, options)
        else:
            ln_file(source_path, dest_path, options)


def main() -> None:
    """Parse arguments and start recursing."""
    options = get_arguments()
    # Absolute, so symlinks resolve from inside the mirrored tree.
    process_dir(options.source.resolve(), Path.cwd(), options)


if __name__ == "__main__":
    main()
