"""Convert relative symlinks into absolute symlinks."""

from pathlib import Path


def relink_file(link_path: Path, *, verbose: bool) -> None:
    """Point the link at its absolute target."""
    target = link_path.resolve()
    link_path.unlink()
    link_path.symlink_to(target)
    if verbose:
        print(f"Relinked {link_path} to {target}")


def abs_link(
    path: str | Path, *, recursive: bool = False, verbose: bool = True
) -> None:
    """Make the symlinks in path absolute, descending into subdirs if recursive."""
    for child in Path(path).iterdir():
        if child.is_symlink():
            relink_file(child, verbose=verbose)
        elif recursive and child.is_dir():
            abs_link(child, recursive=recursive, verbose=verbose)
