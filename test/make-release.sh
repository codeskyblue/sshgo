#!/bin/sh -
#
#

cd $(dirname $0)
VERSION=`./bin/go -v | awk '{print $NF}'`
TMPDIR=`mktemp -d /tmp/go_make_release.XXXXXXXX`
trap "/bin/rm -fr $TMPDIR" EXIT

FOLDER="go-$VERSION"
mkdir $TMPDIR/$FOLDER

while read name alias
do
    test -d $TMPDIR/$FOLDER/$(dirname $name) || mkdir -p $TMPDIR/$FOLDER/$(dirname $name)
    if test -n "$alias"
    then
        cp -rv $name $TMPDIR/$FOLDER/$alias
    else
        cp -rv $name $TMPDIR/$FOLDER
    fi
done <<EOF
    bin
    etc/go.conf.sample etc/go.conf
    bashrc 
    install.sh
    unistall.sh
EOF
#(cd $TMPDIR/$FOLDER; pwd; 
#    pyself gogrep; 
#    pyself go_comp; 
#    rm -fr gogrep.py go_comp.py lib)
    
cd $TMPDIR
find ./ | grep svn | xargs rm -fr  # clean svn
rm -fr $FOLDER/lib

tar -czf $FOLDER.tar.gz $FOLDER
mv $FOLDER.tar.gz $OLDPWD/
printf "make release %s\n" $FOLDER.tar.gz

