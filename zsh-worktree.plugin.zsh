#!/usr/bin/env zsh

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
    echo -e "\twt prune: Prune working tree information"
    echo -e "\twt fetch: Fetch branches from the bare repository"
    echo -e "\twt add <worktree-name>: Create new working tree"
}

# TODO Revisit this method
# Probably I need to create a script to install fzf
# In order for someone to use this method, he needs to have installed FZF
_wt_list() {
    local WORKTREE=$(git worktree list | fzf)

    # if the use exited fzf without choosing a worktree
    if [ -z $WORKTREE ]
    then
        return 0
    fi

    local WORKTREE_PATH=$(echo $WORKTREE | awk '{print $1;}')
    local WORKTREE_COMMIT=$(echo $WORKTREE | awk '{print $2;}')
    local WORKTREE_BRANCH=$(echo $WORKTREE | awk '{print $3;}')

    pushd $WORKTREE_PATH > /dev/null
}

_wt_prune() {
    git worktree prune
}

_wt_add() {
    if ! _wt_fetch; then
        return 1
    fi

    git worktree add $1

    pushd $1 > /dev/null
}

_wt_fetch() {
    if ! _move_to_bare_repo; then
        return 1
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
        _popd_until_stack_is_empty
        echo "There is not a bare repository" > /dev/stderr
        return 1
    fi

    pushd .. > /dev/null
    _move_to_bare_repo
}

_popd_until_stack_is_empty() {
    while (( $? == 0 )); do popd; done
}

_get_current_folder_name() {
    echo $(eval basename $PWD)
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
