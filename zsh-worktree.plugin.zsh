#!/usr/bin/env zsh

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
}

_wt_list() {
    git worktree list
}

wt() {
    if [ -z $1 ]; then
        _help
    elif [ $1 = "list" ]; then
        _wt_list
    fi
}
