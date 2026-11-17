"""Symlink from a directory hierarchy to a flat dir."""

import os
from argparse import ArgumentParser, Namespace
from pathlib import Path


def get_arguments(description: str | None) -> Namespace:
    """Parse the source and destination directory arguments."""
    parser = ArgumentParser(description=description)
    parser.add_argument("src", type=Path, help="Source directory hierarchy")
    parser.add_argument("dest", type=Path, help="Flat destination directory")
    return parser.parse_args()


def flat_link(src: str | Path, dest: str | Path) -> None:
    """Symlink from a directory hierarchy to a flat dir."""
    # Absolute, so the links resolve from inside dest.
    src_path = Path(src).absolute()
    dest_path = Path(dest)
    for root, dirnames, filenames in os.walk(src_path, followlinks=True):
        # Eliminate dotdirs
        dirnames[:] = [dirname for dirname in dirnames if not dirname.startswith(".")]
        root_path = Path(root)
        for filename in filenames:
            if filename.startswith("."):
                # Eliminate dotfiles
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


def main() -> None:
    """Parse arguments and flat link."""
    args = get_arguments(__doc__)
    flat_link(args.src, args.dest)


if __name__ == "__main__":
    main()
