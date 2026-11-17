"""Remove broken symlinks from a dir."""

from pathlib import Path


def purge_flat_links(dest: str | Path, *, verbose: bool = True) -> None:
    """Remove the broken symlinks in dest."""
    for path in Path(dest).iterdir():
        # exists() follows the link from its own directory, not the cwd.
        if path.is_symlink() and not path.exists():
            if verbose:
                print(f"Broken link to {path.readlink()}")
                print(f"rm {path}")
            path.unlink()
