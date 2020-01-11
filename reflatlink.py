#!/usr/bin/env python3
"""Relink a flat link dir."""
from flatlink import flat_link
from purgelink import purge_flat_links


def relink(src, dest):
    """clean up flat links and make new ones where appropriate"""
    purge_flat_links(dest)
    flat_link(src, dest)


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("{} <source> <dest>".format(sys.argv[0]))
        exit(1)
    relink(sys.argv[1], sys.argv[2])
