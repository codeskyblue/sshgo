#!/bin/bash
#
#
cd `dirname $0`
TMPDIR=`mktemp -d $PWD/tmp.XXXX`

test -d "$TMPDIR" && /bin/rm -fr "$TMPDIR"
