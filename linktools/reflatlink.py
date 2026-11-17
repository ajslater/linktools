"""Relink a flat link dir."""

from pathlib import Path

from .flatlink import flat_link, get_arguments
from .purgelink import purge_flat_links


def relink(src: str | Path, dest: str | Path) -> None:
    """Clean up flat links and make new ones where appropriate."""
    purge_flat_links(dest)
    flat_link(src, dest)


def main() -> None:
    """Parse arguments and relink."""
    args = get_arguments(__doc__)
    relink(args.src, args.dest)


if __name__ == "__main__":
    main()
