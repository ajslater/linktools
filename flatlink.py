#!/usr/bin/env python3
"""symlink from a directory hierarchy to a flat dir."""
import os


def flat_link(src, dest):
    """symlink from a directory hierarchy to a flat dir."""
    for root, _, filenames in os.walk(src, followlinks=True):
        for filename in filenames:
            if filename.startswith('.') or '/.' in root:
                # eliminate dotfiles and dotdirs
                continue
            source_path = os.path.join(root, filename)
            link_name = os.path.join(dest, filename)
            if os.path.islink(link_name):
                if os.readlink(link_name) == source_path:
                    continue
            print("ln {} -> {}".format(source_path, link_name))
            os.symlink(source_path, link_name)


if __name__ == "__main__":
    import sys
    flat_link(sys.argv[1], sys.argv[2])
