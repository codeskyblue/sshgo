#!/bin/bash
#
#
cd `dirname $0`
TMPDIR=`mktemp -d $PWD/tmp.XXXX`
test -d "$TMPDIR" || exit 1

tar -xzf src/pyinstaller-2.0.tar.gz -C $TMPDIR
cd $TMPDIR
python pyinstaller-2.0/pyinstaller.py -F ../sshgo.py
mv dist/sshgo ../


test -d "$TMPDIR" && /bin/rm -fr "$TMPDIR"
