#!/usr/bin/env zsh

help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
}

wt_list() {
    git worktree list
}

wt() {
    if [ -z $1 ]; then
        help
    elif [ $1 = "list" ]; then
        wt_list
    fi
}
