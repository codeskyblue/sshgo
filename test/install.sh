#!/bin/sh -
#
# install script for go
#

IFS=' 
	'
PATH="/bin:/usr/bin:/usr/local/bin"
export PATH


DOWNLOAD_URL="http://tool.baidu.com/p/supergo/downloadLatestFile"
PREFIX="$HOME/local/go"

VERSION=1.1  # update old go to new go

CONF_FILE="go.conf"   # for backup

PROFILE="$HOME/.bash_profile"
FLAG="GO"

warning(){ echo "[WARNING]" "$@";    EXITCODE=`expr $EXITCODE + 1`;}
error(){   echo "[ERROR]" "$@";    exit 1;}
prompt(){  echo -n "$1 -> ";shift; echo "$@";}
EXITCODE=0

tmpdir=`mktemp -d /tmp/go_install.XXXXXXXX`;  trap "/bin/rm -fr $tmpdir" EXIT
unistall()
{
    prompt "unistall" "......"

    if test "$force" != "true"
    then
        prompt "unistall" "backup configuration file"
        test -f $PREFIX/$CONF_FILE && cp $PREFIX/$CONF_FILE $tmpdir/bak.$CONF_FILE
        test -f $PREFIX/etc/$CONF_FILE && cp $PREFIX/etc/$CONF_FILE $tmpdir/bak.$CONF_FILE
    fi

    prompt "unistall" "remove path bash_profile setting"
    sed -i "/### $FLAG ENV BEGIN/,/### $FLAG ENV END/d" $PROFILE
    prompt "unistall" "remove $PREFIX folder"
    /bin/rm -fr $PREFIX
}

install()
{
    prompt "install" "......"
    test -d $PREFIX || mkdir -p $PREFIX

    cd $tmpdir
    wget -q "$DOWNLOAD_URL" -O go.tar.gz
    test $? -ne 0 && error "install" "check: download fail"
    prompt "install" "unpack file in $(pwd)"
    tar -xzf go.tar.gz
    cd go-*
    prompt "install" "copy files"
    cp -r * $PREFIX

    cd $PREFIX/

    success=true
    test ! -f $PREFIX/bin/go    && success=false
    test ! -f $PREFIX/bin/gocp  && success=false
    test ! -f $PREFIX/bin/gorun && success=false
    test "$success" == "false" && warning "Checking install False"
    
    prompt "install" "add var to $PROFILE"

    sed -i "\$a### $FLAG ENV BEGIN"  $PROFILE
    echo "PATH=$PREFIX/bin:\$PATH" >> $PROFILE
    echo "test -f $PREFIX/bashrc && source $PREFIX/bashrc" >> $PROFILE
    echo "export PATH" >> $PROFILE
    echo "### $FLAG ENV END" >> $PROFILE

    if test -f $tmpdir/bak.$CONF_FILE
    then
        cp $tmpdir/bak.$CONF_FILE $PREFIX/etc/$CONF_FILE
    fi
}

#
# begin to install
#

force=false
while test $# -ne 0
do
    case $1 in
    --force)
        force=true
        ;;
    --version)
        echo "version $VERSION"
        exit 0
        ;;
    *)
        error "'$1' is not an option"
        ;;
    esac
    shift
done

prompt "run on host" $(hostname)
unistall
install

prompt "install" "finished." 
# echo Please manually run \"source ~/.bash_profile\", then you can use it."

exit $EXITCODE

