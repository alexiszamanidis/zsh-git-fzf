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

_move_to_bare_repo() {
    local IS_BARE_REPO=$(_is_bare_repo)

    if [ $IS_BARE_REPO = "true" ]; then
        echo "Found bare repository: $PWD"
        return 0
    elif [ $PWD = "/" ]; then
        echo "There is not a bare repository" > /dev/stderr
        return 1
    fi

    pushd .. > /dev/null
    _move_to_bare_repo
}

_is_bare_repo() {
    echo $(eval git rev-parse --is-bare-repository)
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
