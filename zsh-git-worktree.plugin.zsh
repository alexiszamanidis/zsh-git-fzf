#!/usr/bin/env zsh

source ${ZSH_CUSTOM}/plugins/zsh-git-worktree/helpers
source ${ZSH_CUSTOM}/plugins/zsh-git-worktree/completions

local FZF_OPTIONS="--no-preview"

_help() {
    echo "Usage:"
    echo -e "\twt list: List details of each working tree. Press ESC to exit or select a worktree to move into it"
    echo -e "\twt prune: Prune working tree information"
    echo -e "\twt fetch: Fetch branches from the bare repository"
    echo -e "\twt add <worktree-name> <(optional-)remote-worktree-name>: Create new working tree"
    echo -e "\twt remove: Remove a working tree"
    echo -e "\twt upgrade: Upgrade zsh-git-worktree plugin"
}

_wt_list() {
    local WORKTREE=$(git worktree list | fzf $FZF_OPTIONS)

    # if the use exited fzf without choosing a worktree
    [ -z $WORKTREE ] && return 0

    local WORKTREE_PATH=$(echo $WORKTREE | awk '{print $1;}')
    local WORKTREE_COMMIT=$(echo $WORKTREE | awk '{print $2;}')
    local WORKTREE_BRANCH=$(echo $WORKTREE | awk '{print $3;}')

    pushd $WORKTREE_PATH > /dev/null
}

_wt_prune() {
    git worktree prune
}

_wt_remove() {
    local WORKTREE=$(git worktree list | fzf $FZF_OPTIONS)

    # if the use exited fzf without choosing a worktree
    [ -z $WORKTREE ] && return 0

    local HOLD_PATH=$PWD
    local WORKTREE_PATH=$(echo $WORKTREE | awk '{print $1;}')
    local WORKTREE_BRANCH=$(basename $WORKTREE_PATH)

    [ $HOLD_PATH = $WORKTREE_PATH ] && _move_to_bare_repo

    local WORKTREE_REMOVE_OUTPUT=$(git worktree remove $WORKTREE_BRANCH 2>&1)

    # if the worktree was removed successfully => prune and return
    [ -z $WORKTREE_REMOVE_OUTPUT ] && _wt_prune && return 0

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
    if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]; then
        colorful_echo "Illegal number of parameters" "RED"
        return 1
    fi

    local HOLD_PATH=$PWD
    local BRANCH_NAME=$1
    local REMOTE_BRANCH_NAME=$2

    local WORKTREE_EXISTS=$(_exists_worktree $BRANCH_NAME)
    if [ $WORKTREE_EXISTS = "true" ]; then
        colorful_echo "Worktree named already exists: '$BRANCH_NAME'" "RED"
        return 1
    fi

    if ! _move_to_bare_repo; then
        pushd $HOLD_PATH > /dev/null
        return 1
    fi

    _bare_repo_fetch

    local BARE_REPO_PATH=$PWD
    local NEW_WORKTREE_PATH=$BARE_REPO_PATH/$BRANCH_NAME

    local WORKTREE=""
    [[ $# -eq 1 ]] && WORKTREE=$(git worktree list | fzf $FZF_OPTIONS)

    local BRANCH_EXISTS=$(_exists_remote_repository $BRANCH_NAME)

    if [[ $# -eq 1 ]]; then
        # if the use exited fzf without choosing a worktree, this means that the we want to clone a remote branch
        if [[ -z $WORKTREE ]]; then
            if [ $BRANCH_EXISTS = "false" ]; then
                colorful_echo "Remote branch named: '$BRANCH_NAME' does not exist" "RED"
                pushd $HOLD_PATH > /dev/null
                return 1
            fi
            colorful_echo "Creating worktree from remote branch" "GREEN"
            git worktree add $NEW_WORKTREE_PATH
            git branch --set-upstream-to=origin/$BRANCH_NAME $BRANCH_NAME
            pushd $NEW_WORKTREE_PATH > /dev/null
            git pull
            return 0
        else
            # otherwise create a worktree from a local branch

            if [ $BRANCH_EXISTS = "true" ]; then
                colorful_echo "Remote branch named: '$BRANCH_NAME' already exists" "RED"
                return 1
            fi

            colorful_echo "Creating worktree from local branch" "GREEN"

            local WORKTREE_PATH=$(echo $WORKTREE | awk '{print $1;}')

            pushd $WORKTREE_PATH > /dev/null

            git worktree add -b $BRANCH_NAME $NEW_WORKTREE_PATH
            git push --set-upstream origin $BRANCH_NAME
        fi
    fi

    if [[ ! -z $REMOTE_BRANCH_NAME ]] && [[ $# -eq 2 ]]; then
        if [ $BRANCH_EXISTS = "true" ]; then
            colorful_echo "Remote branch named: '$BRANCH_NAME' already exists" "RED"
            pushd $HOLD_PATH > /dev/null
            return 1
        fi

        local REMOTE_BRANCH_EXISTS=$(_exists_remote_repository $REMOTE_BRANCH_NAME)
        if [ $REMOTE_BRANCH_EXISTS = "false" ]; then
            colorful_echo "Remote branch named: '$REMOTE_BRANCH_NAME' does not exist" "RED"
            pushd $HOLD_PATH > /dev/null
            return 1
        fi
        colorful_echo "Creating worktree from remote branch" "GREEN"
        git worktree add --track -b $BRANCH_NAME $NEW_WORKTREE_PATH origin/$REMOTE_BRANCH_NAME
        git push --set-upstream origin $BRANCH_NAME
    fi

    # if there is an installation script, execute it
    # TODO pass installation script as an argument(absolute path?)
    # Is there a git hook for this process?
    if [ -f $NEW_WORKTREE_PATH/install ]; then
        chmod +x $NEW_WORKTREE_PATH/install
        $NEW_WORKTREE_PATH/install
    fi

    # if there is a custom editor, open the worktree
    # TODO edge case for vim, which is a terminal editor
    # Do I actualy need this?? Maybe this command can be included in the installation script!?!
    # if [ ! -z $EDITOR ]
    # then
    #     eval $EDITOR $NEW_WORKTREE_PATH
    #     return 0
    # fi

    # otherwise move into the worktree
    pushd $NEW_WORKTREE_PATH > /dev/null
}

_exists_worktree() {
    local WORKTREE=$1
    local COMMAND="git worktree list | awk '{print \$3;}' | awk '/\[$WORKTREE\]/{print \$1}'"
    local WORKTREE_FOUND=$(eval $COMMAND)

    if [ ! -z $WORKTREE_FOUND ]; then
        echo "true"
    else
        echo "false"
    fi
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

# TODO: is there a better way to implement this??
_remove_local_that_do_not_exist_on_remote_repository() {
    git remote update --prune > /dev/null
    git branch -vv | awk '/: gone]/{print $1}' | xargs --no-run-if-empty git branch -d > /dev/null
}

_bare_repo_fetch() {
    git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    _remove_local_that_do_not_exist_on_remote_repository
    git fetch --all --prune > /dev/null
}

# TODO: is there a better way to implement this??
_move_to_bare_repo() {
    local BARE_REPO_PATH=$(eval git worktree list | awk '/bare/{print $1}')

    [ -z $BARE_REPO_PATH ] && echo "Bare repository does not exist" > /dev/stderr && return 1

    # echo "Found bare repository: $BARE_REPO_PATH"
    pushd $BARE_REPO_PATH > /dev/null
    return 0
}

_upgrade_plugin() {
    local HOLD_PATH=$PWD

    pushd ${ZSH_CUSTOM}/plugins/zsh-git-worktree > /dev/null

    # TODO: is there anything better than this? for checking if the repository needs pull
    git fetch &> /dev/null
    diffs=$(git diff main origin/main)

    if [ -z "$diffs" ]
    then
        colorful_echo "Already up to date" "GREEN"
        pushd $HOLD_PATH > /dev/null
        return 0
    fi

    git pull
    colorful_echo "zsh-git-worktree plugin has been upgraded successfully. Restart your shell or reload config file(.zshrc)." "GREEN"
    pushd $HOLD_PATH > /dev/null
}

wt() {
    if ! hash fzf 2>/dev/null; then
        colorful_echo "You need to install fzf: https://github.com/junegunn/fzf" "RED"
        return 1
    fi

    local OPERATION=$1
    [ -z $OPERATION ] && _help && return 0
    [ $OPERATION = "upgrade" ] && _upgrade_plugin && return 0

    local IS_GIT_REPOSITORY="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
    if [[ ! $IS_GIT_REPOSITORY ]]; then
        colorful_echo "You need to be inside a git repository" "RED"
        return 1
    fi

    if [ $OPERATION = "list" ]; then
        _wt_list
    elif [ $OPERATION = "prune" ]; then
        _wt_prune
    elif [ $OPERATION = "fetch" ]; then
        _wt_fetch
    elif [ $OPERATION = "add" ]; then
        _wt_add ${@:2} # pass all arguments except the first one(add)
    elif [ $OPERATION = "remove" ]; then
        _wt_remove
    else
        _help
    fi
}
