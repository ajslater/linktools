#!/usr/bin/env python
"""Relink a flat link dir."""
from purgelink import purge_flat_links
from flatlink import flat_link


def relink(src, dest):
    """clean up flat links and make new ones where appropriate"""
    purge_flat_links(dest)
    flat_link(src, dest)


if __name__ == "__main__":
    import sys
    relink(sys.argv[1], sys.argv[2])
