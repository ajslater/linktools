"""Remove broken symlinks from a flat dir, then flat link into it again."""

lazy from pathlib import Path

from .flatlink import flat_link
from .purgelink import purge_flat_links


def relink(src: str | Path, dest: str | Path, *, verbose: bool = True) -> None:
    """Clean up flat links and make new ones where appropriate."""
    purge_flat_links(dest, verbose=verbose)
    flat_link(src, dest, verbose=verbose)
