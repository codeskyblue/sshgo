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

VERSION=1.0
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
        cp $PREFIX/$CONF_FILE $tmpdir/bak.$CONF_FILE
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
    test ! -f $PREFIX/go    && success=false
    test ! -f $PREFIX/gocp  && success=false
    test ! -f $PREFIX/gorun && success=false
    test "$success" == "false" && warning "Checking install False"
    
    prompt "install" "add var to $PROFILE"

    sed -i "\$a### $FLAG ENV BEGIN"  $PROFILE
    echo "PATH=$PREFIX:\$PATH" >> $PROFILE
    echo "test -f $PREFIX/bashrc && source $PREFIX/bashrc" >> $PROFILE
    echo "export PATH" >> $PROFILE
    echo "### $FLAG ENV END" >> $PROFILE

    if test -f $tmpdir/bak.$CONF_FILE
    then
        cp $tmpdir/bak.$CONF_FILE $PREFIX/$CONF_FILE
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

cat > $PREFIX/$CONF_FILE <<EOF
[chunjie]
userpass = root,mAtrix
userpass = work,mAtrix
hostname = szwg-hadoop-t0000.szwg01
hostname = szwg-hadoop-t0001.szwg01
hostname = szwg-hadoop-t0002.szwg01
hostname = szwg-hadoop-t0003.szwg01
hostname = szwg-hadoop-t0004.szwg01
hostname = szwg-hadoop-t0005.szwg01
hostname = szwg-hadoop-t0006.szwg01
hostname = szwg-hadoop-t0007.szwg01
hostname = szwg-hadoop-t0008.szwg01
hostname = szwg-hadoop-t0009.szwg01
hostname = szwg-hadoop-t0010.szwg01
hostname = szwg-hadoop-t0011.szwg01
hostname = szwg-hadoop-t0012.szwg01
hostname = szwg-hadoop-t0013.szwg01
hostname = szwg-hadoop-t0014.szwg01
hostname = szwg-hadoop-t0015.szwg01
hostname = szwg-hadoop-t0016.szwg01
hostname = szwg-hadoop-t0017.szwg01
hostname = szwg-hadoop-t0018.szwg01
hostname = szwg-hadoop-t0019.szwg01
hostname = szwg-hadoop-t0020.szwg01
hostname = szwg-hadoop-t0021.szwg01
hostname = szwg-hadoop-t0022.szwg01
hostname = szwg-hadoop-t0023.szwg01
hostname = szwg-hadoop-t0024.szwg01
hostname = szwg-hadoop-t0025.szwg01
hostname = szwg-hadoop-t0026.szwg01
hostname = szwg-hadoop-t0027.szwg01
hostname = szwg-hadoop-t0028.szwg01
hostname = szwg-hadoop-t0029.szwg01
hostname = szwg-hadoop-t0030.szwg01
hostname = szwg-hadoop-t0031.szwg01
hostname = szwg-hadoop-t0032.szwg01
hostname = szwg-hadoop-t0033.szwg01
hostname = szwg-hadoop-t0034.szwg01
hostname = szwg-hadoop-t0035.szwg01
hostname = szwg-hadoop-t0036.szwg01
hostname = szwg-hadoop-t0037.szwg01
hostname = szwg-hadoop-t0038.szwg01
hostname = szwg-hadoop-t0039.szwg01
hostname = szwg-hadoop-t0040.szwg01
hostname = szwg-hadoop-t0041.szwg01
hostname = szwg-hadoop-t0042.szwg01
hostname = szwg-hadoop-t0043.szwg01
hostname = szwg-hadoop-t0044.szwg01
hostname = szwg-hadoop-t0045.szwg01
hostname = szwg-hadoop-t0046.szwg01
hostname = szwg-hadoop-t0047.szwg01
hostname = szwg-hadoop-t0048.szwg01
hostname = szwg-hadoop-t0049.szwg01
EOF
prompt "install" "finished." 
# echo Please manually run \"source ~/.bash_profile\", then you can use it."

exit $EXITCODE

