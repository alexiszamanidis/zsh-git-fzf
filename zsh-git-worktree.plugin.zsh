#!/usr/bin/env zsh

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree"
    echo -e "\twt prune: Prune working tree information"
    echo -e "\twt fetch: Fetch branches from the bare repository"
    echo -e "\twt add <worktree-name> <(optional-)remote-worktree-name>: Create new working tree"
    echo -e "\twt remove: Remove a working tree"
    echo -e "\twt upgrade: Upgrade zsh-git-worktree plugin"
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
    local WORKTREE=$(git worktree list | fzf)

    # if the use exited fzf without choosing a worktree
    if [ -z $WORKTREE ]
    then
        return 0
    fi

    local HOLD_PATH=$PWD
    local WORKTREE_PATH=$(echo $WORKTREE | awk '{print $1;}')
    local WORKTREE_BRANCH=$(basename $WORKTREE_PATH)

    if [ $HOLD_PATH = $WORKTREE_PATH ]; then
        _move_to_bare_repo
    fi

    local WORKTREE_REMOVE_OUTPUT=$(git worktree remove $WORKTREE_BRANCH 2>&1)

    # if the worktree was removed successfully
    if [ -z $WORKTREE_REMOVE_OUTPUT ]
    then
        _wt_prune
        return 0
    fi

    echo $WORKTREE_REMOVE_OUTPUT

    local UNTRACKED_OR_MODIFIED_FILES="fatal: '$WORKTREE_BRANCH' contains modified or untracked files, use --force to delete it"

    if [ $WORKTREE_REMOVE_OUTPUT != $UNTRACKED_OR_MODIFIED_FILES ]; then
        pushd $HOLD_PATH > /dev/null
        return 0
    fi

    read "response?Force delete? [Y/n]"
    response=${response:l} #tolower
    if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
        git worktree remove -f $WORKTREE_BRANCH
        _wt_prune
        return 0
    fi

    pushd $HOLD_PATH > /dev/null
}

_exists_remote_repository() {
    local BRANCH=$1
    local WORKTREE_EXISTS=$(eval git ls-remote origin $BRANCH)
    if [ ! -z $WORKTREE_EXISTS ]
    then
        echo "true"
    else
        echo "false"
    fi
}

_wt_add() {
    local HOLD_PATH=$PWD
    local BRANCH_NAME=$1
    local REMOTE_BRANCH_NAME=$2

    if ! _move_to_bare_repo; then
        pushd $HOLD_PATH > /dev/null
        return 1
    fi

    _bare_repo_fetch

    local BARE_REPO_PATH=$PWD
    local NEW_WORKTREE_PATH=$BARE_REPO_PATH/$BRANCH_NAME

    pushd $HOLD_PATH > /dev/null

    local WORKTREE_EXISTS=$(_exists_remote_repository $BRANCH_NAME)
    if [ $WORKTREE_EXISTS = "true" ]; then
        git worktree add $NEW_WORKTREE_PATH
    else
        if [ ! -z $REMOTE_BRANCH_NAME ]
        then
            git worktree add --track -b $BRANCH_NAME $NEW_WORKTREE_PATH origin/$REMOTE_BRANCH_NAME
        else
            git worktree add -b $BRANCH_NAME $NEW_WORKTREE_PATH
        fi
        git push --set-upstream origin $BRANCH_NAME
    fi


    # if there is an installation script, execute it
    # TODO pass installation script as an argument(absolute path?)
    if [ -f $NEW_WORKTREE_PATH/install ]; then
        chmod +x $NEW_WORKTREE_PATH/install
        $NEW_WORKTREE_PATH/install
    fi

    # if there is a custom editor, open the worktree
    # TODO edge case for vim, which is a terminal editor
    # if [ ! -z $EDITOR ]
    # then
    #     eval $EDITOR $NEW_WORKTREE_PATH
    #     return 0
    # fi

    # otherwise move into the worktree
    pushd $NEW_WORKTREE_PATH > /dev/null
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

_upgrade_plugin() {
    pushd ~/.oh-my-zsh/custom/plugins/zsh-git-worktree > /dev/null
    git pull
    popd > /dev/null
    echo "zsh-git-worktree plugin has been upgraded successfully. Restart your shell or reload config file(.zshrc)."
}

wt() {
    local OPERATION=$1
    if [ -z $OPERATION ]; then
        _help
    elif [ $OPERATION = "list" ]; then
        _wt_list
    elif [ $OPERATION = "prune" ]; then
        _wt_prune
    elif [ $OPERATION = "fetch" ]; then
        _wt_fetch
    elif [ $OPERATION = "add" ]; then
        _wt_add ${@:2}
    elif [ $OPERATION = "remove" ]; then
        _wt_remove
    elif [ $OPERATION = "upgrade" ]; then
        _upgrade_plugin
    else
        _help
    fi
}
