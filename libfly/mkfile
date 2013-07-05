#!/usr/bin/env python
#
# Modify:   2012-9-22
# By:       Sun,Shengxiang
#
# need python version >= 1.6
#
# usage:
#       mkfile.py   filesize  filename
#
# params:
#       filesize can be 1, 1K, 1M, 1G  (default Byte)
#
# return:
#       create a file and print its md5
#

import hashlib, random, sys
import getopt
import string

# global definitions
quiet = False

def rdchar():
    ''' random char '''
    return random.choice(string.printable) #[c for c in 'ABCDEabcdefghijklmnopqrstuvwxyz\n\t\r1234567890'])

def rdnchar(n = 1024*4): # default 4K
    return rdchar() * n

def sizeconv(str_size):
    ''' convert size to bytes count, support B, K, M, G'''
    pown = 0
    if not str_size.isdigit():
        unit = str_size[-1]
        for u in 'BKMG': 
            if u == unit.upper(): break
            pown += 1
        size = float(str_size[:-1]) * pow(1024, pown)
    else:
        size = float(str_size)
    return int(size)

def make_random_file(filename, str_size):
    ''' write random chars to file '''
    size = sizeconv(str_size)
    m = hashlib.md5()
    fd = open(filename, 'wb')
    if size > 100*1024:  ds = 32*1024
    else:                ds = 4
    while size > 0:
        ds = min(ds, size)
        s = rdnchar(ds)
        fd.write(s)
        size -= ds
        if not quiet:
            m.update(s)
    fd.close()
    if not quiet: print '%s  %s' %(m.hexdigest(), filename)

def usage_and_exit(exitcode = 0):
    print '''Usage: ./mkfile.py [OPTIONS] <SIZE> [filename(default: file)] 
[DESCRIPTION]
    generate random file, and sum up the md5

[OPTIONS]
    -q      quiet, suppress md5 sum print

[SIZE]
    eg: 1b 1k 1m 1g  this is same as 1B 1K 1M 1G
'''
    sys.exit(exitcode)
    
if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'qh', ['quiet', 'help'])
        for k, v in opts:
            if k == '-q' or k == '--quiet':
                quiet = True
            elif k == '-h' or k == '--help':
                usage_and_exit(0)

    except getopt.GetoptError:
        usage_and_exit(1)

    if len(args) == 0:
        usage_and_exit(1)

    strsize = args[0]

    filelist = args[1:]
    if not filelist:
        filelist.append('file') # file is the default name
    # create random files
    for name in filelist:
        make_random_file(name, strsize)

