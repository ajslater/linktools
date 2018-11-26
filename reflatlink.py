#!/usr/bin/env python
"""Relink a flat link dir."""
import os


def purge_flat_links(dest):
    """purge broken links in a flat dir."""
    for filename in os.listdir(dest):
        path = os.path.join(dest, filename)
        if os.path.islink(path) and not os.path.exists(os.readlink(path)):
            print os.readlink(path)
            print "rm {}".format(path)
            os.remove(path)


def flat_link(src, dest):
    """symlink from a directory hierarchy to a flat dir."""
    for root, _, filenames in os.walk(src):
        for filename in filenames:
            if filename.startswith('.'):
                continue
            source_path = os.path.join(root, filename)
            link_name = os.path.join(dest, filename)
            if os.path.islink(link_name):
                if os.readlink(link_name) == source_path:
                    continue
            print "ln {} -> {}".format(source_path, link_name)
            os.symlink(source_path, link_name)


def relink(argv):
    """clean up flat links and make new ones where appropriate"""
    src = argv[1]
    dest = argv[2]

    purge_flat_links(dest)
    flat_link(src, dest)


if __name__ == "__main__":
    import sys
    relink(sys.argv)
