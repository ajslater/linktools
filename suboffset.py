#!/usr/bin/python
"""
   Script to offset the time in subtitle files in the .srt format. Script
   takes in the filename and the offset (in milliseconds) to add or
   subtract from the subtitles. It then writes the new subtitles to the
   same file. Alternately you can specify the filename as '-' and then
   the script will read input from stdin and write output to stdout.

"""

__version__   = '1.0'
__author__    = 'Einar Egilsson'
__date__      = 'March 20th 2008'
__url__       = 'http://tech.einaregilsson.com/2008/03/20/subtitle-fixer/' 

import sys, re, datetime

MILLISECOND = 1
SECOND = 1000 * MILLISECOND
MINUTE = 60 * SECOND
HOUR = 60 * MINUTE

def offset_time(time, offset):
    """ Takes in list with [hour, minute, second, millisecond] and returns
        it with offset milliseconds added and normalized
    """
    ms = sum(map(int.__mul__,  time, [HOUR, MINUTE, SECOND, MILLISECOND]))
    ms += offset
    return [ms / HOUR, ms % HOUR / MINUTE, ms % MINUTE / SECOND, ms % SECOND]

def fix_subtitles(lines, offset, output):
    """ Takes in list (lines) with all the lines from the subtitle file, adds
        offset milliseconds to it and writes the file to output.
    """
    for line in lines:
        pattern = r'(\d\d):(\d\d):(\d\d),(\d\d\d) --> (\d\d):(\d\d):(\d\d),(\d\d\d)'
        match = re.match(pattern, line)
        if match:
            nrs = [int(nr) for nr in match.groups(0)]
            start = offset_time(nrs[:4], offset)
            end = offset_time(nrs[4:], offset)
            output.write('%02d:%02d:%02d,%03d' % tuple(start))
            output.write(' --> ')
            output.write('%02d:%02d:%02d,%03d\n' % tuple(end))
        else:
            output.write(line)

def print_header():
    print 'Subtitle Fixer v%s' % __version__
    print 'Author: %s' % __author__
    print __url__
    print ''

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print_header()
        print 'Usage: suboffset.py <filename> <offset-in-milliseconds>'
        print 'Use - for filename to read from stdin and print to stdout'
        sys.exit(1)

    offset = int(sys.argv[2])
    file = None
    if sys.argv[1] == '-': #Read from stdin and print to stdout
        fix_subtitles(sys.stdin.readlines(), offset, sys.stdout)
    else: #read from file and write to same file
        file = open(sys.argv[1], 'r')
        lines = file.readlines()
        file.close()
        file = open(sys.argv[1], 'w')
        fix_subtitles(lines, offset, file)
        file.close()
        print 'Finished adding %s milliseconds to %s' % (offset, sys.argv[1])
