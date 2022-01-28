#!/usr/bin/env zsh

source ~/.oh-my-zsh/custom/plugins/zsh-git-fzf/src/operations/worktree
source ~/.oh-my-zsh/custom/plugins/zsh-git-fzf/src/operations/status
source ~/.oh-my-zsh/custom/plugins/zsh-git-fzf/src/operations/branch
source ~/.oh-my-zsh/custom/plugins/zsh-git-fzf/src/operations/checkout

_help() {
    echo "Usage:"
    echo -e "\tgit-fzf worktree: Worktree operations"
    echo -e "\tgit-fzf status: Show paths that have differences between the index file and the current HEAD commit"
    echo -e "\tgit-fzf branch: Show both local and remote branches"
    echo -e "\tgit-fzf checkout: Switch branches"
    echo -e "\tgit-fzf upgrade: Upgrade zsh-git-fzf plugin"
}

_upgrade_plugin() {
    local HOLD_PATH=$PWD

    pushd ~/.oh-my-zsh/custom/plugins/zsh-git-fzf > /dev/null

    # TODO: is there anything better than this? for checking if the repository needs pull
    git fetch &> /dev/null
    diffs=$(git diff main origin/main)

    if [ -z "$diffs" ]
    then
        colorful_echo "Already up to date"
        pushd $HOLD_PATH > /dev/null
        return 0
    fi

    git pull
    colorful_echo "zsh-git-fzf plugin has been upgraded successfully. Restart your shell or reload config file(source ~/.zshrc)."
    pushd $HOLD_PATH > /dev/null
}

git-fzf() {
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

    if [ $OPERATION = "worktree" ]; then
        _worktree ${@:2} # pass all arguments except the first one(add)
    elif [ $OPERATION = "status" ]; then
        _status
    elif [ $OPERATION = "branch" ]; then
        _branch
    elif [ $OPERATION = "checkout" ]; then
        _checkout
    else
        _help
    fi
}

alias gfzf="git-fzf"
# alias gf="git-fzf"
