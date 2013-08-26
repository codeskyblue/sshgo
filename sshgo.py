#!/usr/bin/env python
#coding: utf-8
#
# Need python >= 2.7.   Author:SUN SHENGXIANG 20130826
# 

import os
import sys
import argparse
import dict4ini

default_username = ''
default_password = ''

# parse arguments
parser = argparse.ArgumentParser(description = "sshgo ~ jump through machines")
parser.add_argument('-u', dest='user', help='specify user', default='work', action='store')
parser.add_argument('-d', dest='debug', help='debug on/off', default=False, action='store_true')
parser.add_argument('-t', dest='test', help='only show hostname, no use ssh', default=False, action='store_true')
parser.add_argument(dest='host', help='hostname', nargs=1)
parser.add_argument(dest='args', help='arguments', nargs='*')

opts = parser.parse_args()
if opts.debug:
	print 'DEBUG [ON]'


def dirname(path):
    dir = os.path.dirname(path)
    if dir == "": dir = '.'
    return dir

def readlinkf(link_file):
    ''' return absolupath of link file destination '''
    if not os.path.islink(link_file): return link_file
    p = os.readlink(link_file)
    if not os.path.isabs(p):
        p = os.path.join(dirname(link_file), p)
    return readlinkf(p)

selfdir = os.path.dirname(readlinkf(__file__))

hosts = []
hsets = {}

try:
	ini = dict4ini.DictIni(os.path.join(selfdir, 'sshgo.ini'))
except Exception, e:
	print e
	sys.exit(1)
	
if ini.get('default'):
	default_username = ini.get('default').get('username')
	default_password = ini.get('default').get('password')

if opts.debug:
	print 'default ~ user:%s, passwd:%s' %(default_username, default_password)

for key in ini.keys():
	username = ini.get(key).get('username', default_username)
	password = ini.get(key).get('password', default_password)
	for host in ini.get(key).get('hostname', []):
		#print host, username, password
		hosts.append(host)
		hsets[host] = (username, password)

def dp(string, patten, a = 0, b = 0, f = 0):
    ''' 
        AUTHOR(ssx): add comment on 2012-12-21
        string is like(bb-testing-oped2012.vm)
        patten is like(bb2012)
        return (string, rank), the high rank the better
    '''
    if b >= len(patten): return '', 0
    if a >= len(string): return '', 0
    
    stra, ra = dp(string, patten, a+1, b, 0)

    if string[a] == patten[b]:
        strb, rb = dp(string, patten, a+1, b+1, 1)
        strb = string[a] + strb
        if   len(strb) > len(stra):
            return strb, rb+f
        elif len(strb) == len(stra):
            if rb+f > ra:
                return strb, rb+f
    return stra, ra

def find(strings, patten):
	max = 0
	matches = []
	for s in strings:
		mstr, score = dp(s, patten)
		if opts.debug:
			print 'Host:%s Matched:%s Score:%d' %(s, mstr, score)
		if score > max:
			max = score
			matches = [s]
		elif score == max:
			matches.append(s)
		else:
			pass
	return matches
			

patten  = opts.host[0]
matches = find(hosts, patten)

if len(matches) > 1:
	print 'Too many matched hosts ...'
	for host in matches: print '\t', host
elif len(matches) == 0:
	print 'No hostname found'
else:
	host = matches[0]
	username, password = hsets[host]
	if opts.user:
		username = opts.user
	if opts.test:
		print host
	else:
		os.environ['SSHPASS'] = password
		params = ['exec', 'sshpass', '-e', 'ssh', '-o', 'StrictHostKeyChecking=no', '%s@%s'%(username, host)]
		params.extend(opts.args)
		os.system(' '.join(params))

