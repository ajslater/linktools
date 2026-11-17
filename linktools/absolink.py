"""Converts relative symlinks into absolute symlinks."""

from argparse import ArgumentParser, Namespace
from pathlib import Path

__version__ = "0.1.2"


def get_arguments() -> Namespace:
    """Parse command line arguments."""
    parser = ArgumentParser(description=__doc__)
    parser.add_argument(
        "path",
        nargs="?",
        type=Path,
        default=Path.cwd(),
        help="Directory to convert. Defaults to the current directory.",
    )
    parser.add_argument(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        help="Don't give progress info",
    )
    parser.add_argument(
        "-r",
        "--recursive",
        action="store_true",
        help="Descend into subdirectories",
    )
    return parser.parse_args()


def relink_file(link_path: Path, options: Namespace) -> None:
    """Convert the link."""
    target = link_path.resolve()
    link_path.unlink()
    link_path.symlink_to(target)
    if options.verbose:
        print(f"Relinked {link_path} to {target}")


def process_dir(dir_path: Path, options: Namespace) -> None:
    """Find and descend into subdirectories."""
    for path in dir_path.iterdir():
        if path.is_symlink():
            relink_file(path, options)
        elif options.recursive and path.is_dir():
            process_dir(path, options)


def main() -> None:
    """Get options and recursively link."""
    options = get_arguments()
    process_dir(options.path, options)


if __name__ == "__main__":
    main()
