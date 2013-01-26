#!/usr/bin/env python
#
"""
 Converts relative symlinks into absolute symlinks
"""

__version__ = '0.1.1'

import os
import optparse


def get_options_and_arguments():
    """returns the options and the arguments"""
    usage = "usage: %prog [options]"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-q", "--quiet", action="store_false",
                      dest="verbose", default=1,
                      help="Don't give progress info")
    parser.add_option("-r", "--recursive", action="store_true",
                      dest="recursive", default=0,
                      help="Converts symbolic links to absolute symbolic"
                           "links")

    options_and_arguments = parser.parse_args()

    return options_and_arguments[0]


def abs_link_file(link_file_name, options):
    """converts the link"""
    link_target_file_name = os.readlink(link_file_name)
    if (not os.path.isabs(link_target_file_name)):
        absolute_source_file_name = os.path.realpath(link_target_file_name)

        if options.verbose:
            print("Absolutizing symlink to", absolute_source_file_name)
        os.remove(link_file_name)
        os.symlink(absolute_source_file_name, link_file_name)


def cd_dir(dir_name, options):
    """finds and descends into subdirectories"""
    os.chdir(dir_name)
    dir_list = os.listdir(".")  # os.getcwd())

    for file_name in dir_list:
        if os.path.islink(file_name):
            abs_link_file(file_name, options)
        elif options.recursive and os.path.isdir(file_name):
            cd_dir(file_name, options)
            os.chdir("..")


def main():
    """do the deed"""
    options = get_options_and_arguments()
    cd_dir(os.getcwd(), options)

if __name__ == '__main__':
    main()
