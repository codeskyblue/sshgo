#!/usr/bin/env python
# coding: utf-8

import sys
import base64
import gzip
import StringIO
import random
import string

def encrypt(passwd):
    ''' passwd: string which need to be encrypt '''
    f = StringIO.StringIO()
    gz = gzip.GzipFile(fileobj = f, mode = 'wb')
    gz.write(passwd)
    gz.flush()
    gz.close()
    f.seek(0)
    
    step1 = f.read()    # encoded by gzip

    # add shuffle to head
    length = len(step1)
    rchars = ''
    for i in xrange(4):
        rc = random.choice(string.letters)
        rchars += rc
    return base64.b64encode(rchars[:2] + step1 + rchars[2:])


def decrypt(enc_passwd):
    ''' decrypt simple enc passwd '''
    # remove shuffle
    step1 = base64.b64decode(enc_passwd)[2:-2]
    f = StringIO.StringIO(step1)
    gz = gzip.GzipFile(fileobj = f)
    return gz.read()
   
if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'Usage: %s [-d, --decrypt] [-e, --encrypt] [-t, --test]  string' % 'gencrypt'
        sys.exit(0)
    arg1, arg2 = sys.argv[1:]
    if arg1 in ('-e', '--encrypt'):
        print encrypt(arg2)
    elif arg1 in ('-d', '--decrypt'):
        try:
            print decrypt(arg2)
        except:
            print 'The input is not recognize by program'
    elif arg1 in ['-t', '--test']:
        s = encrypt(arg2)
        print 'encrypted:', s
        print 'decrypted:', decrypt(s)

