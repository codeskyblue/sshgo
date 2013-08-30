## README ##
* Created:    2013-01-09
* By:         shxsun

## How to Hack or Build dist file
first install python2.7, clone files to local

* easy\_install pexpect
* easy\_install keyring

use `sh build.sh` to get dist file(sshgo)

## Config File
default is a key word. store default username and password
each group(like shxsun) store batch of machines.

	[default]
	username = work
	password = 123456

	[shxsun]
	hostname[] = example1.com
	hostname[] = example2.com

## How to use
* `sshgo ex1`  to jump to example1.com
* `sshgo e2` to jump to example2.com

ex1 and e2 are short of example1.com and example2.com

if you use `sshgo ex`, sshgo will just print the two machines, and exit

## Relative information ##
[a modify sshpass support yes/no](https://github.com/xurenlu/sshpass/blob/master/main.c)
