#!/usr/bin/env zsh

source ~/.oh-my-zsh/custom/plugins/zsh-git-worktree/src/operations/worktree

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
    fi
}

alias gfzf="git-fzf"
# alias gf="git-fzf"
