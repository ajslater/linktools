#!/usr/bin/env python3
"""symlink from a directory hierarchy to a flat dir."""
import os
from logging import getLogger
from pathlib import Path

LOG = getLogger(__name__)


def flat_link(src, dest):
    """Symlink from a directory hierarchy to a flat dir."""
    dest_path = Path(dest)
    for root, _, filenames in os.walk(src, followlinks=True):
        root_path = Path(root)
        for filename in filenames:
            if filename.startswith(".") or "/." in root:
                # eliminate dotfiles and dotdirs
                continue
            source_path = root_path / filename
            link_name = dest_path / filename

            if link_name.is_symlink():
                if link_name.resolve() != source_path.resolve():
                    # Remove bad link
                    link_name.unlink()
                else:
                    # Already linked
                    continue
            elif link_name.exists():
                print(f"file: {link_name} blocking creation of symlink.")
                continue

            print(f'ln "{source_path}" => "{link_name}"')
            link_name.symlink_to(source_path)


if __name__ == "__main__":
    import sys

    flat_link(sys.argv[1], sys.argv[2])
