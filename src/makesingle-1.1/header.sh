#!/bin/sh
skip=14
tmpdir=`/bin/mktemp -d ${TMPDIR:-/tmp}/makesingle.XXXXXXXXXX` || exit 1
prog="${tmpdir}/`echo \"$0\" | sed 's|^.*/||'`"
if /usr/bin/tail +$skip "$0" | tar -xz -C $tmpdir; then
  /bin/chmod 700 "$prog"
  trap '/bin/rm -rf $tmpdir; exit $res' EXIT
  "$prog" ${1+"$@"}; res=$?
else
  echo "Cannot untar $0"
  /bin/rm -rf $tmpdir
  exit 1
fi; exit $res
