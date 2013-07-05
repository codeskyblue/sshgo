#!/bin/sh
#
# monitor network stream
#

in=
out=

function finish(){
	read fin fout <<<`cat /proc/net/dev | grep eth | cut -d: -f2- | awk '{print $1,$9}'`
	echo ""
	echo $sin $fin $sout $fout |
		awk '{
			printf("%-3s:  %.2lfM\n", "In", ($2-$1)/1024/1024) ;
			printf("%-3s:  %.2lfM\n", "Out", ($4-$3)/1024/1024) ;
		}'
	exit $?
}

trap "finish" SIGHUP SIGINT


cat /proc/net/dev | grep eth | awk -F: '{print "Interface: "$1}'
read sin sout <<<`cat /proc/net/dev | grep eth | cut -d: -f2- | awk '{print $1,$9}'`

read -p ""
