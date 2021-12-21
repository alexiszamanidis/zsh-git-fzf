#!/usr/bin/env zsh

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
    echo -e "\twt prune: Prune working tree information"
    echo -e "\twt fetch: Fetch branches from the bare repository"
    echo -e "\twt add <worktree-name>: Create new working tree"
}

_wt_list() {
    git worktree list
}

_wt_prune() {
    git worktree prune
}

_wt_add() {
    _wt_fetch

    git worktree add $1

    cd $1
}

_wt_fetch() {
    if ! _move_to_bare_repo; then
        return 0
    fi

    _bare_repo_fetch
}

# TODO: i need to revisit this method
_bare_repo_fetch() {
    # set config so we can make the fetch
    git config remote.origin.fetch 'refs/heads/*:refs/heads/*'
    git fetch
    # undo
    git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
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
    elif [ $1 = "fetch" ]; then
        _wt_fetch
    elif [ $1 = "add" ] && [ $# -eq 2 ]; then
        _wt_add $2
    fi
}
