"""Mirror a directory tree with hard or symbolic links to its files."""

from pathlib import Path


def ln_file(
    source_path: Path, dest_path: Path, *, symlink: bool, verbose: bool
) -> None:
    """Link the target file."""
    if dest_path.exists() or dest_path.is_symlink():
        return

    if verbose:
        pref = "Syml" if symlink else "L"
        print(f"{pref}inking {source_path} to {dest_path}")

    if symlink:
        dest_path.symlink_to(source_path)
    else:
        dest_path.hardlink_to(source_path)


def process_dir(
    source_dir: Path, dest_dir: Path, *, symlink: bool, flatten: bool, verbose: bool
) -> None:
    """Traverse the source directory tree, creating mirror directories."""
    if not dest_dir.is_dir():
        if verbose:
            print(f"Creating {dest_dir} from {source_dir}")
        dest_dir.mkdir()

    for source_path in sorted(source_dir.iterdir()):
        dest_path = dest_dir / source_path.name
        if source_path.is_dir():
            new_dest_dir = dest_dir if flatten else dest_path
            process_dir(
                source_path,
                new_dest_dir,
                symlink=symlink,
                flatten=flatten,
                verbose=verbose,
            )
        else:
            ln_file(source_path, dest_path, symlink=symlink, verbose=verbose)


def hier_link(
    src: str | Path,
    dest: str | Path,
    *,
    symlink: bool = False,
    flatten: bool = False,
    verbose: bool = True,
) -> None:
    """Mirror the src tree into dest, linking its files."""
    # Absolute, so symlinks resolve from inside the mirrored tree.
    process_dir(
        Path(src).resolve(),
        Path(dest),
        symlink=symlink,
        flatten=flatten,
        verbose=verbose,
    )
