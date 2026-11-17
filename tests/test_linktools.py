"""Run each link tool through its command line entry point."""

import sys
from pathlib import Path
from types import ModuleType

import pytest

from linktools import absolink, flatlink, hierlink, purgelink, reflatlink


def _run(monkeypatch: pytest.MonkeyPatch, module: ModuleType, *argv: str | Path):
    monkeypatch.setattr(sys, "argv", [module.__name__, *map(str, argv)])
    module.main()


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


def test_flatlink(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Link every file but dotfiles into one flat dir, from relative paths."""
    monkeypatch.chdir(src.parent)
    _run(monkeypatch, flatlink, "src", "dest")
    assert _names(dest) == ["a.txt", "b.txt"]
    assert (dest / "b.txt").readlink() == src / "sub" / "b.txt"
    assert (dest / "b.txt").read_text() == "b.txt"


def test_purgelink(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Remove only broken links, even when the cwd is elsewhere."""
    (dest / "good").symlink_to(Path("..") / "src" / "a.txt")
    (dest / "broken").symlink_to(Path("..") / "src" / "missing.txt")
    monkeypatch.chdir(src / "sub")
    _run(monkeypatch, purgelink, dest)
    assert _names(dest) == ["good"]


def test_reflatlink(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Purge broken links and link the files again."""
    (dest / "broken").symlink_to(src / "missing.txt")
    (dest / "a.txt").symlink_to(src / "sub" / "b.txt")
    _run(monkeypatch, reflatlink, src, dest)
    assert _names(dest) == ["a.txt", "b.txt"]
    assert (dest / "a.txt").readlink() == src / "a.txt"


def test_absolink(monkeypatch: pytest.MonkeyPatch, src: Path):
    """Make relative links absolute, descending only with --recursive."""
    (src / "link").symlink_to("a.txt")
    (src / "sub" / "link").symlink_to("b.txt")
    _run(monkeypatch, absolink, "-q", src)
    assert (src / "link").readlink() == src / "a.txt"
    assert (src / "sub" / "link").readlink() == Path("b.txt")
    _run(monkeypatch, absolink, "-qr", src)
    assert (src / "sub" / "link").readlink() == src / "sub" / "b.txt"


def test_hierlink(monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path):
    """Mirror the tree into the cwd with hard links."""
    monkeypatch.chdir(dest)
    _run(monkeypatch, hierlink, "-q", src)
    assert _names(dest) == [".dot.txt", ".hidden", "a.txt", "sub"]
    linked = dest / "sub" / "b.txt"
    assert not linked.is_symlink()
    assert linked.samefile(src / "sub" / "b.txt")


def test_hierlink_symlink_flatten(
    monkeypatch: pytest.MonkeyPatch, src: Path, dest: Path
):
    """Symlink the whole tree flat into the cwd."""
    monkeypatch.chdir(dest)
    _run(monkeypatch, hierlink, "-q", "-s", "-f", src)
    assert _names(dest) == [".dot.txt", "a.txt", "b.txt", "c.txt"]
    assert (dest / "b.txt").readlink() == src / "sub" / "b.txt"
