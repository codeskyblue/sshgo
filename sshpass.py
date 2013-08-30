#!/usr/bin/env python

''' Automate SSH logins when you're force to authenticate with a password. '''
import getpass
import optparse
import os
import sys

import keyring
import pexpect

def getpassword(service, username):
    ''' Get password from keychain '''
    
    password = keyring.get_password(service, username)

    while not password:
        # ask and save a password.
        password = getpass.getpass("password: ")
        if not password:
            print "Please enter a password"

    return password

def gettermsize():
    ''' horrible non-portable hack to get the terminal size to transmit
        to the child process spawned by pexpect '''
    (rows, cols) = os.popen("stty size").read().split() # works on Mac OS X, YMMV
    rows = int(rows)
    cols = int(cols)
    return (rows, cols)

def setpassword(keychainservice, username, password):
    ''' Save password in keychain '''

    if not keyring.get_password(keychainservice, username):
        print>>sys.stderr,  "Successful login - saving password for user %s under keychain service '%s'" % (username, keychainservice)
        keyring.set_password(keychainservice, username, password)

    
def ssh(username, host, keychainservice="ssh_py_default", port=22, args = []):
    ''' Automate sending password when the server has public key auth disabled '''

    password = getpassword(keychainservice, username)

    print>>sys.stderr,  "Connecting to %s@%s" % (username, host)

    cmd = "/usr/bin/ssh -p%d %s@%s %s" % (port, username, host, ' '.join(args))
    child = pexpect.spawn(cmd)

    (rows, cols) = gettermsize()
    child.setwinsize(rows, cols) # set the child to the size of the user's term

    # handle the host acceptance and password crap.
    i = -1
    try:
        i = child.expect(['Are you sure you want to continue connecting (yes/no)?', 'assword:'])
    except:
        print>>sys.stderr,  'Connection Failed, please check manually.'
        return
        
    if i == 0:
        # accept the host
        print>>sys.stderr,  "New server, accept the host..."
        child.sendline('yes')
        child.expect('assword:')

    print>>sys.stderr, "Sending password"
    child.sendline(password)

    if len(args) == 0:
        # assume we see a shell prompt ending in $ to denote successful login:
        print>>sys.stderr,  "Waiting for $ shell prompt terminator to confirm login..."
        if child.expect(r'\$') == 0:
            setpassword(keychainservice, username, password)
            child.sendline()
    # give control to the human.
    child.interact()

if __name__=='__main__':
    parser = optparse.OptionParser(usage="ssh.py [options] <username@>host")

    parser.add_option("-k", "--keychainservice", dest="keychainservice", help="Keychain service name to store password under", 
                     default="ssh_py_default")
    parser.add_option("-p", "--port", dest="port", help="SSH port", default=22)

    (opts, args) = parser.parse_args()

    if len(args) != 1:
        parser.print_usage()
        sys.exit(1)

    host_str = args[0]
    if host_str.find("@") != -1:
        (username, host) = host_str.split("@")
    else:
        username = os.getlogin() # default to username on the current host.
        host = host_str

    ssh(username, host, port=int(opts.port), keychainservice=opts.keychainservice)
