#!/bin/sh

IFS=' 
	'

PATH="/usr/local/bin:/usr/bin:/bin"
export PATH

UMASK=002
umask $UMASK

error()
{
    echo "$@" 1>&2
    usage_and_exit 1
}

version()
{
    echo "$PROGRAM version $VERSION"
}

warning()
{
    echo "$@" 1>&2
    EXITCODE=`expr $EXITCODE + 1`
}

usage(){ cat <<-EOF
Usage: 
    $PROGRAM 
        The programer is too lazy, and he didn't write any thing.
EOF
}

usage_and_exit()
{
    usage
    exit $1
}

# return the absolute path
abspath(){
    echo $(cd $(dirname $1); pwd)/$(basename $1)
}

CWD=$(dirname $FULLNAME)

EXITCODE=0
PROGRAM=`basename $0`

VERSION='no info of version'
GOCONF="$CWD/../etc/go.conf"
GOGREP="$CWD/gogrep --flag=$PROGRAM" # -f $GCONF"
GO="$CWD/go"
GOCP="$CWD/gocp"
GORUN="$CWD/gorun"

