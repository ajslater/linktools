"""Symlink every file in a directory hierarchy into one flat dir."""

from pathlib import Path


def flat_link(src: str | Path, dest: str | Path, *, verbose: bool = True) -> None:
    """Symlink every file under src, but dotfiles and dotdirs, into dest."""
    # Absolute, so the links resolve from inside dest.
    src_path = Path(src).absolute()
    dest_path = Path(dest)
    for root, dirnames, filenames in src_path.walk(follow_symlinks=True):
        # Eliminate dotdirs
        dirnames[:] = [dirname for dirname in dirnames if not dirname.startswith(".")]
        for filename in filenames:
            if filename.startswith("."):
                # Eliminate dotfiles
                continue
            source_path = root / filename
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

            if verbose:
                print(f'ln "{source_path}" => "{link_name}"')
            link_name.symlink_to(source_path)
