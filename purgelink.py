#!/usr/bin/env python3
"""purge broken links in a flat dir."""
import os


def purge_flat_links(dest):
    """Purge broken links in a flat dir."""
    for filename in os.listdir(dest):
        path = os.path.join(dest, filename)
        if os.path.islink(path) and not os.path.exists(os.readlink(path)):
            print(os.readlink(path))
            print("rm {}".format(path))
            os.remove(path)


if __name__ == "__main__":
    import sys

    purge_flat_links(sys.argv[1])
