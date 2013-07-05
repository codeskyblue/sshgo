#!/bin/sh
#
# install basic tools for deploy
#

if test `whoami` != root
then
	echo "Must be run as root"
	exit 1
fi

cp -v daemon /usr/bin/
cp -v dlprod /usr/bin/
cp -v psfind /usr/bin/
cp -v sshpass /usr/bin/
