#!/bin/sh
#
# common function, include initial envionment
#
#

if test `whoami` != root
then
	echo "Must run as root"
	exit 1
fi

cd `dirname $0`
cp -fv daemon /usr/bin
cp -fv dlprod /usr/bin
cp -fv sshpass /usr/bin

