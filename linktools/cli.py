"""Tools for creating and manipulating trees of symlinks."""

from argparse import ArgumentParser
from importlib.metadata import version
from pathlib import Path
lazy from collections.abc import Callable, Sequence
lazy from types import ModuleType

from . import absolink, flatlink, hierlink, purgelink, reflatlink


def get_parser() -> ArgumentParser:
    """Build the parser and its commands."""
    quiet = ArgumentParser(add_help=False)
    quiet.add_argument(
        "-q",
        "--quiet",
        action="store_false",
        dest="verbose",
        help="Don't give progress info",
    )
    src_dest = ArgumentParser(add_help=False)
    src_dest.add_argument("src", type=Path, help="Source directory hierarchy")
    src_dest.add_argument("dest", type=Path, help="Flat destination directory")

    parser = ArgumentParser(prog="linktools", description=__doc__)
    parser.add_argument("--version", action="version", version=version("linktools"))
    commands = parser.add_subparsers(title="commands", metavar="COMMAND", required=True)

    def add(
        name: str,
        module: ModuleType,
        func: Callable[..., None],
        *parents: ArgumentParser,
    ) -> ArgumentParser:
        command = commands.add_parser(
            name,
            parents=[quiet, *parents],
            help=module.__doc__,
            description=module.__doc__,
        )
        # main() calls func with the parsed arguments as keywords.
        command.set_defaults(func=func)
        return command

    add("flat", flatlink, flatlink.flat_link, src_dest)
    purge = add("purge", purgelink, purgelink.purge_flat_links)
    purge.add_argument("dest", type=Path, help="Flat directory of links")
    add("reflat", reflatlink, reflatlink.relink, src_dest)

    absolute = add("abs", absolink, absolink.abs_link)
    absolute.add_argument(
        "path",
        nargs="?",
        type=Path,
        default=Path.cwd(),
        help="Directory to convert. Defaults to the current directory.",
    )
    absolute.add_argument(
        "-r", "--recursive", action="store_true", help="Descend into subdirectories"
    )

    hier = add("hier", hierlink, hierlink.hier_link)
    hier.add_argument("src", type=Path, help="Source directory")
    hier.add_argument(
        "dest",
        nargs="?",
        type=Path,
        default=Path.cwd(),
        help="Directory to mirror into. Defaults to the current directory.",
    )
    hier.add_argument(
        "-s",
        "--symlink",
        action="store_true",
        help="Create symbolic links instead of hard links",
    )
    hier.add_argument(
        "-f",
        "--flatten",
        action="store_true",
        help="Do not create a directory structure on the destination side, just a big flat collection of links to the source tree",
    )
    return parser


def main(argv: Sequence[str] | None = None) -> None:
    """Run a linktools command."""
    kwargs = vars(get_parser().parse_args(argv))
    func = kwargs.pop("func")
    func(**kwargs)
