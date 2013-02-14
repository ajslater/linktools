#!/usr/bin/env python
""" Creates a collection of symlinks to a directory hierarchy effectively
    flattening the heirarchy. Useful if you need to reference all the files
    in a hierarchy from one directory without a recursive search.
"""

import os
import optparse
import fnmatch
import sys
import re

__version__ = '0.1.1'


def compile_ignore_regex(opts):
    """ complile the multiple ignore globs into one regex """
    if not opts.ignore:
        return

    regex_list = []
    for ignore_glob in opts.ignore:
        regex_list.append(fnmatch.translate(ignore_glob))

    regex = '|'.join(regex_list)
    reobj = re.compile(regex)

    # re-uses the ignore attribute.
    return setattr(opts, 'ignore', reobj)


def get_options_and_arguments():
    """ get all the options and arguments """
    usage = "usage: %prog [options] <target directory>"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-q", "--quiet", action="store_false",
                      dest="verbose", default=True,
                      help="Do not display output")
    parser.add_option("-l", "--hardlink", action="store_true",
                      dest="hardlink", default=False,
                      help="create hard links instead of symbolic links")
    parser.add_option("-i", "--ignore", action="append",
                      dest="ignore", default=None,
                      help="ignore paths with this glob. Specify multiple "
                           "times for multiple ignore globs")
    opts, args = parser.parse_args()

    if not args or not os.path.isdir(args[0]):
        parser.print_help()
        sys.exit(1)

    compile_ignore_regex(opts)

    return (opts, args[0])


def ln_file(full_filename, filename, options):
    """ link a single file either with a hard or symbolic link"""
    if options.verbose:
        if options.hardlink:
            pref = 'Hard '
        else:
            pref = 'Sym'
        print pref + 'linking ' + full_filename + ' to ' + filename

    if (os.path.exists(filename)):
        print 'ERROR ' + filename + 'already exists.'
    else:
        if options.hardlink:
            os.link(full_filename, filename)
        else:
            os.symlink(full_filename, filename)


def cd_dir(target_dir, options):
    """ recursivly decend directories looking for files,
        ignoring those specified"""
    target_dir_list = os.listdir(target_dir)
    target_dir_list.sort()

    for filename in target_dir_list:
        full_filename = os.path.normpath(target_dir + os.sep + filename)
        if options.ignore and options.ignore.search(full_filename):
            continue

        if os.path.isdir(full_filename):
            cd_dir(full_filename, options)
        else:
            ln_file(full_filename, filename, options)


def main():
    """ main program """
    (options, target_dir) = get_options_and_arguments()
    cd_dir(target_dir, options)


if __name__ == '__main__':
    main()
