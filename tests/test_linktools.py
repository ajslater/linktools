"""Run each linktools command through the command line."""

from importlib.metadata import version
from pathlib import Path
lazy from typing import Final

import pytest

from linktools.cli import main

EXIT_USAGE: Final = 2


def _run(*argv: str | Path) -> None:
    main([str(arg) for arg in argv])


def _names(path: Path) -> list[str]:
    return sorted(child.name for child in path.iterdir())


@pytest.fixture
def src(tmp_path: Path) -> Path:
    """Make a source hierarchy with a dotfile and a dotdir."""
    src = tmp_path / "src"
    (src / "sub").mkdir(parents=True)
    (src / ".hidden").mkdir()
    for path in (
        src / "a.txt",
        src / "sub" / "b.txt",
        src / ".dot.txt",
        src / ".hidden" / "c.txt",
    ):
        path.write_text(path.name)
    return src.resolve()


@pytest.fixture
def dest(tmp_path: Path) -> Path:
    """Make an empty destination dir."""
    dest = tmp_path / "dest"
    dest.mkdir()
    return dest.resolve()


def test_flat(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Link every file but dotfiles into one flat dir, from relative paths."""
    monkeypatch.chdir(src.parent)
    _run("flat", "src", "dest")
    assert _names(dest) == ["a.txt", "b.txt"]
    assert (dest / "b.txt").readlink() == src / "sub" / "b.txt"
    assert (dest / "b.txt").read_text() == "b.txt"


def test_purge(
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
    src: Path,
    dest: Path,
):
    """Quietly remove only broken links, even when the cwd is elsewhere."""
    (dest / "good").symlink_to(Path("..") / "src" / "a.txt")
    (dest / "broken").symlink_to(Path("..") / "src" / "missing.txt")
    monkeypatch.chdir(src / "sub")
    _run("purge", "-q", dest)
    assert _names(dest) == ["good"]
    assert not capsys.readouterr().out


def test_reflat(src: Path, dest: Path):
    """Purge broken links and link the files again."""
    (dest / "broken").symlink_to(src / "missing.txt")
    (dest / "a.txt").symlink_to(src / "sub" / "b.txt")
    _run("reflat", src, dest)
    assert _names(dest) == ["a.txt", "b.txt"]
    assert (dest / "a.txt").readlink() == src / "a.txt"


def test_abs(src: Path):
    """Make relative links absolute, descending only with --recursive."""
    (src / "link").symlink_to("a.txt")
    (src / "sub" / "link").symlink_to("b.txt")
    _run("abs", "-q", src)
    assert (src / "link").readlink() == src / "a.txt"
    assert (src / "sub" / "link").readlink() == Path("b.txt")
    _run("abs", "-qr", src)
    assert (src / "sub" / "link").readlink() == src / "sub" / "b.txt"


def test_hier(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Mirror the tree into the cwd with hard links."""
    monkeypatch.chdir(dest)
    _run("hier", "-q", src)
    assert _names(dest) == [".dot.txt", ".hidden", "a.txt", "sub"]
    linked = dest / "sub" / "b.txt"
    assert not linked.is_symlink()
    assert linked.samefile(src / "sub" / "b.txt")


def test_hier_symlink_flatten(src: Path, dest: Path):
    """Symlink the whole tree flat into an explicit dest."""
    _run("hier", "-q", "-s", "-f", src, dest)
    assert _names(dest) == [".dot.txt", "a.txt", "b.txt", "c.txt"]
    assert (dest / "b.txt").readlink() == src / "sub" / "b.txt"


def test_no_command(capsys: pytest.CaptureFixture[str]):
    """Print usage and exit with a usage error without a command."""
    with pytest.raises(SystemExit) as excinfo:
        main([])
    assert excinfo.value.code == EXIT_USAGE
    assert "usage: linktools" in capsys.readouterr().err


def test_version(capsys: pytest.CaptureFixture[str]):
    """Print the package version."""
    with pytest.raises(SystemExit) as excinfo:
        main(["--version"])
    assert excinfo.value.code == 0
    assert capsys.readouterr().out.strip() == version("linktools")
