#!/usr/bin/env zsh

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
    echo -e "\twt prune: Prune working tree information"
}

_wt_list() {
    git worktree list
}

_wt_prune() {
    git worktree prune
}

wt() {
    if [ -z $1 ]; then
        _help
    elif [ $1 = "list" ]; then
        _wt_list
    elif [ $1 = "prune" ]; then
        _wt_prune
    fi
}
