#!/usr/bin/env zsh

EDITOR=""

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
    echo -e "\twt prune: Prune working tree information"
    echo -e "\twt fetch: Fetch branches from the bare repository"
    echo -e "\twt add <worktree-name>: Create new working tree"
    echo -e "\twt remove <worktree-name>: Remove a working tree"
    echo -e "\twt editor <your-editor-open-command>: Open working tree. If you want to reset your editor, just run: 'wt editor'"
}

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

_wt_remove() {
    local WORKTREE_REMOVE_OUTPUT=$(git worktree remove $1 2>&1)

    # if the worktree was removed successfully
    if [ -z $WORKTREE_REMOVE_OUTPUT ]
    then
        _wt_prune
        return 0
    fi

    echo $WORKTREE_REMOVE_OUTPUT

    local UNTRACKED_OR_MODIFIED_FILES="fatal: '$1' contains modified or untracked files, use --force to delete it"

    if [ $WORKTREE_REMOVE_OUTPUT != $UNTRACKED_OR_MODIFIED_FILES ]; then
        return 0
    fi

    read "response?Force delete? [Y/n]"
    response=${response:l} #tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
        git worktree remove -f $1
        _wt_prune
    fi
}

_wt_add() {
    local HOLD_PATH=$PWD

    if ! _move_to_bare_repo; then
        pushd $HOLD_PATH > /dev/null
        return 1
    fi

    _bare_repo_fetch

    git worktree add $1

    # if there is a custom editor, open the worktree and move back to your path
    # TODO edge case for vim, which is a terminal editor
    if [ ! -z $EDITOR ]
    then
        eval $EDITOR ./$1
        pushd $HOLD_PATH > /dev/null
        return 0
    fi

    # otherwise move into the worktree
    pushd $1 > /dev/null
}

_wt_fetch() {
    local HOLD_PATH=$PWD

    if ! _move_to_bare_repo; then
        pushd $HOLD_PATH > /dev/null
        return 1
    fi

    _bare_repo_fetch

    pushd $HOLD_PATH > /dev/null
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

# TODO refactor and use this function instead of holding the path(e.g. HOLD_PATH)
_popd_until_stack_is_empty() {
    while (( $? == 0 )); do popd; done
}

_get_current_folder_name() {
    echo $(eval basename $PWD)
}

_is_bare_repo() {
    echo $(eval git rev-parse --is-bare-repository)
}

_update_editor() {
    sed -i "s/EDITOR=\".*/EDITOR=\"$1\"/g" ~/.oh-my-zsh/custom/plugins/zsh-worktree/zsh-worktree.plugin.zsh
    echo "You editor has been updated successfully. You need to open a new zsh terminal or reload(source again) your .zshrc!"
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
    elif [ $1 = "editor" ]; then
        _update_editor $2
    elif [ $1 = "add" ] && [ $# -eq 2 ]; then
        _wt_add $2
    elif [ $1 = "remove" ] && [ $# -eq 2 ]; then
        _wt_remove $2
    else
        _help
    fi
}
