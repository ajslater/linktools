"""Purge broken links in a flat dir."""

from argparse import ArgumentParser
from pathlib import Path


def purge_flat_links(dest: str | Path) -> None:
    """Purge broken links in a flat dir."""
    for path in Path(dest).iterdir():
        # exists() follows the link from its own directory, not the cwd.
        if path.is_symlink() and not path.exists():
            print(f"Broken link to {path.readlink()}")
            print(f"rm {path}")
            path.unlink()


def main() -> None:
    """Parse arguments and purge."""
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("dest", type=Path, help="Flat directory of links")
    args = parser.parse_args()
    purge_flat_links(args.dest)


if __name__ == "__main__":
    main()
