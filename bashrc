#!/bin/bash
#
# @author   sunshengxiang
# @modify   2012-10-9
#

#
# include: make source strong
#
include(){
    test $# -eq 0 && return
    pushd "$(dirname $0)" >/dev/null
    for name in $@
    do
        pushd "$(dirname $name)" >/dev/null
        source "./$(basename $name)"
        popd >/dev/null
    done
    popd >/dev/null
}
    
export -f include

#
# complete words
#

comp_test()
{
    COMPREPLY=()
    CUR="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=(`compgen -W "hello wall warning what whatever world" $CUR`)
}

comp_gocp()
{
    local CUR #PREV
    CUR="${COMP_WORDS[COMP_CWORD]}"
    #PREV="${COMP_WORDS[COMP_CWORD-1]}"
    go_comp="$HOME/local/go/bin/go_comp"

    COMPREPLY=()
    if echo "$CUR" | grep -q ':'
    then
        local HOST DIR FILE OPTS
        IFS=: read HOST PATH_PREFIX <<-EOF
            $CUR
		EOF
        OPTS=`gorun $HOST $go_comp $PATH_PREFIX`
        COMPREPLY=(`compgen -W "$OPTS" $PATH_PREFIX`)
    else
        PATH_PREFIX=$CUR
        OPTS=`$go_comp $PATH_PREFIX`
        COMPREPLY=(`compgen -W "$OPTS" $PATH_PREFIX`)
    fi
}

complete -F comp_test hello
complete -F comp_gocp gocp

