#!/usr/bin/env python3
"""purge broken links in a flat dir."""
from pathlib import Path


def purge_flat_links(dest):
    """Purge broken links in a flat dir."""
    dest = Path(dest)
    for path in dest.iterdir():
        if path.is_symlink() and not path.readlink().exists():
            print(f"Broken link to {path.readlink()}")
            print(f"rm {path}")
            path.unlink()


if __name__ == "__main__":
    import sys

    purge_flat_links(sys.argv[1])
