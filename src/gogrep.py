#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Find machine by simple input
#
import os
import sys
import getopt

import lib.config
import lib.statistic

__version__ = '1.8'
__author__  = 'sunshengxiang'

if hasattr(sys, 'frozen'):
    __file__ = sys.executable

__dir__ = os.path.dirname(os.path.abspath(__file__))

_conf = os.path.join(__dir__, '../etc/go.conf')

def search(string, patten, a = 0, b = 0, f = 0):
    ''' 
        AUTHOR(ssx): add comment on 2012-12-21
        string is like(bb-testing-oped2012.vm)
        patten is like(bb2012)
        return (string, rank), the high rank the better
    '''
    if b >= len(string): return '', 0
    if a >= len(patten): return '', 0
    
    stra, ra = search(string, patten, a+1, b, 0)

    if string[a] == patten[b]:
        strb, rb = search(string, patten, a+1, b+1, 1)
        strb = string[a] + strb
        if   len(strb) > len(stra):
            return strb, rb+f
        elif len(strb) == len(stra):
            if rb+f > ra:
                return strb, rb+f
    return stra, ra

def dp(A, B, a = 0, b = 0, f = 0):
    ''' 
        a is index of A, b is index of B
        f(flag), 1 when A[a-1] and B[b-1] are matched
        return (string, rank), the high the rank the best
    '''
    if b >= len(B): return '', 0
    if a >= len(A): return '', 0
    
    stra, ra = dp(A, B, a+1, b, 0)

    if A[a] == B[b]:
        strb, rb = dp(A, B, a+1, b+1, 1)
        strb = A[a] + strb
        if   len(strb) > len(stra):
            return strb, rb+f
        elif len(strb) == len(stra):
            if rb+f > ra:
                return strb, rb+f
    return stra, ra

def print_and_exit(msg, exitcode = 1):
    print msg
    sys.exit(exitcode)
    
__username = None
__all      = False
flag = 'gogrep'

if __name__ == "__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'f:u:a', ['flag='])
        for k, v in opts:
            if   k == '-u':
                __username = v
            elif k == '-a':
                __all = True
            elif k == '--flag':
                flag = v
            elif k == '-f':
                _conf = v
                
    except getopt.GetoptError:
        print 'getopt error'
        sys.exit(1)

    # health check
    if len(args) == 1:
        patten = args[0]
    else:
        print_and_exit('need one argument')
        
    if not os.path.isfile(_conf):
        print_and_exit('go.conf not found')
    cf = lib.config.config(_conf)
    # end of health check

    wishlist = []  # store hostname and password
    for gp in cf.sections():
        userpass = None  # username = [username, password]
        ''' get username and password '''
        if __username:
            for up in cf.get(gp, 'userpass', multi = True):
                u, p = up.split(',', 1) # u:username, p:password
                if u == __username:
                    userpass = [u, p]
                    break
        else:
            userpass = cf.get(gp, 'userpass')
            if userpass != None:
                userpass = userpass.split(',', 1)
        # no user found if run to here
        if userpass == None:
            continue
     
        for hostname in cf.get(gp, 'hostname', multi = True):
            str, rank = dp(hostname, patten)
            if str == patten:
                wishlist.append((rank, hostname, userpass))

    # print hostname, username, password
    wishlist.sort(reverse = True)
    # h: host, rk: rank, up: userpass
    if __all:
        format_str = '{user}@{host} {password}'
    else:
        format_str = '{host}'

    result =  [ format_str.format(host=h, user=up[0], password=up[1]) \
            for rk, h, up in wishlist[:] if rk == wishlist[0][0]]

    result = {}.fromkeys(result).keys() # uniq
    for line in result:
        print line
            
    cnt = len(result)
    # sys.exit
    if cnt == 1:
        import socket
        message = '%-6s: %-38s %-38s %s' %(flag, socket.gethostname(), wishlist[0][1], wishlist[0][2][0])
        lib.statistic.client_report(message)
        sys.exit(0)
    elif cnt == 0:
        sys.exit(1)
    else:
        sys.exit(2)

