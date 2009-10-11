#!/usr/bin/env python
"""
Hierlink makes a mirrored tree of directories with symlinks to the 
source files
"""
__revision__ = '0.1.0'

import os, optparse

def get_options_and_arguments() :
    """parses command line arguments"""
    usage = "usage: %prog [options] <source directory>"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-q", "--quiet", action="store_false", dest="verbose", 
        default=1, help="Do not display output")
    parser.add_option("-s", "--symlink", action="store_true", dest="symlink",
        default=0, help="crease symbolic links intead of hard links")
    parser.add_option("-f", "--flatten", action="store_true", dest="flatten",
        default=0, help="Does not create a directory structure on the"+
	"destination side, just a big flat collection of links to the"+ 
	"source tree")

    (options, arguments) = parser.parse_args()
  
    if len(arguments) <= 0 :
        print usage

    return (options, arguments)


def ln_file(source_filename, dest_filename, options) :
    """Links the target file or creates a mirror directory"""
    dest_dirname = os.path.dirname(dest_filename)

    if options.verbose :
        if options.symlink :
            pref = 'Syml'
        else :
            pref = 'L'

    print pref+'inking '+source_filename+' to '+dest_filename

    if not os.path.exists(dest_filename) :
        if not os.path.exists(dest_dirname) :
            if options.verbose :                               
                print 'Creating '+ dest_dirname +' from '+ source_filename
            os.mkdir(dest_dirname)
      
        if options.symlink :
            os.symlink(source_filename, dest_filename)
        else :
            os.link(source_filename, dest_filename)


def cd_dir(source_dirname, dest_dirname, options, relpath) :
    """Traverses the source directory tree"""
    if (not os.path.isdir(dest_dirname)) :
        os.mkdir(dest_dirname)
    os.chdir(dest_dirname)
    source_dirlist = os.listdir(source_dirname)
    source_dirlist.sort()
  
    for filename in source_dirlist :
        source_filename = source_dirname+os.sep+filename
        dest_filename = dest_dirname+os.sep+filename
    
        if os.path.isdir(source_filename) :
            if relpath and not options.flatten :
                newsource_dirname = os.pardir+os.sep+source_filename
            else :
                newsource_dirname = source_filename

            if options.flatten :
                newdest_dirname = dest_dirname
            else :
                newdest_dirname = dest_filename
      
            cd_dir(newsource_dirname, newdest_dirname, options, relpath)
        else :
            ln_file(source_filename, dest_filename, options)


def main() :
    """main"""
    (options, arguments)=get_options_and_arguments()
  
    if len(arguments) > 0 :
        source_dir = os.path.normpath(arguments[0])
        relpath = os.path.abspath(source_dir) != source_dir
    else :
        relpath = 0

    if options.verbose and relpath :
        print 'Source directory '+source_dir+' is a relative path.'
 
        cd_dir(source_dir, os.getcwd(), options, relpath)

if __name__ == '__main__':
    # Import Psyco if available
    try:
	import psyco
	print "I'm going psyCo!"
	psyco.full()
    except ImportError:
	pass
    main()
