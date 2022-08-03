# zsh-git-fzf

A ZSH plugin that wraps git operations for simplicity and productivity. Also, it **contains completions** and **combines the FZF** tool to make the operations more convenient.

**You can find my plugin listed among other useful plugin in the [awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) repository!**

## Table of Contents

-   [Benefits](https://github.com/alexiszamanidis/zsh-git-fzf#benefits)
-   [Dependencies](https://github.com/alexiszamanidis/zsh-git-fzf#dependencies)
-   [Installation](https://github.com/alexiszamanidis/zsh-git-fzf#installation)
-   [Usage](https://github.com/alexiszamanidis/zsh-git-fzf#usage)
-   [Supported operations](https://github.com/alexiszamanidis/zsh-git-fzf#supported-operations)
-   [Properties](https://github.com/alexiszamanidis/zsh-git-fzf#properties)
-   [ZSH preferred keybinds](https://github.com/alexiszamanidis/zsh-git-fzf#zsh-preferred-keybinds)
-   [Hooks](https://github.com/alexiszamanidis/zsh-git-fzf#hooks)
-   [Contribution](https://github.com/alexiszamanidis/zsh-git-fzf#contribution)
-   [License](https://github.com/alexiszamanidis/zsh-git-fzf#license)

## Benefits

-   Interactive
-   Simplicity and Productivity
-   Plugin completions. After typing `git-fzf `, `gfzf ` or `gf `, press `TAB` to view the completions ([Demo](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/DEMO.md#completions))
-   git worktree
    -   Simpler API
    -   No need to `cd` around. After you have created a git worktree you will be moved into it
    -   You will never stash your changes again

## Dependencies

-   Git version: 2.34.1
-   [fzf](https://github.com/junegunn/fzf): This tool will be installed by the installation script

## Installation

1. Install Plugin

```
wget -q https://raw.githubusercontent.com/alexiszamanidis/zsh-git-fzf/master/install -O install && \
chmod +x install && \
./install && \
rm -rf ./install
```

2.  Add plugin to plugin list

-   Open .zshrc(e.g. code .zshrc, vim .zshrc)
-   Add plugin to plugin list

```
plugins=(... zsh-git-fzf)
```

3. Restart your shell or reload config file(source ~/.zshrc)

## Usage

After installing the plugin you can execute **git-fzf help** to check the operations that are provided:

### Supported operations

-   `git-fzf branch`

    Search for both local and remote branches ([Demo](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/DEMO.md#branch))

-   `git-fzf checkout`

    Search for a branch and checkout into it ([Demo](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/DEMO.md#checkout))

-   `git-fzf diff`

    Show changes between commits, commit and working tree, etc

-   `git-fzf stash`

    Show stash entities

-   `git-fzf reflog`

    Show reflog entities

-   `git-fzf log`

    Show commit logs

-   `git-fzf worktree [worktree-operation]`

    **add**

    -   Create a new worktree:
        -   Run the following command: `git-fzf worktree add [new-branch]`
        -   After executing the command above, select a working tree from the fzf results and it will create a new worktree for you checked out from the remote branch you selected
            -   if you do not select a remote branch(ESC), it will create a new worktree with the new branch you typed. This was made for convenience, instead of having `git worktree add master master`, you can just run `git worktree add master`

    **remove**

    -   Remove a worktree

        -   Run the following command: `git-fzf worktree remove`
        -   After executing the command above, select a working tree from the fzf results and the selected worktree will be removed

        **Restrictions**

        -   You cannot delete the same Worktree as the one you are currently working on

    **list**

    -   List all worktrees
        -   Run the following command: `git-fzf worktree list`
        -   After executing the command above, close the fzf by pressing `ESC`
    -   Switch worktree
        -   Run the following command: `git-fzf worktree list`
        -   After executing the command above, select a working tree from the fzf results and you will be moved into the selected working tree

    **clean**

    -   Removes all working trees that do not have a corresponding remote repository

### Properties

You can add the following properties to your .zshrc file:

| Property                            | Type   | Default value | Description                                                 |
| ----------------------------------- | ------ | ------------- | ----------------------------------------------------------- |
| ZSH_GIT_FZF_REMOVE_STALLED_BRANCHES | string | false         | Removes local(stalled) branches that do not exist on remote |

### ZSH preferred keybinds

Include the code below in your .zshrc file

```bash
bindkey -s ^o "git-fzf checkout\n"
bindkey -s ^l "git-fzf log\n"
bindkey -s ^d "git-fzf diff\n"
```

### Hooks

If you want to execute automatically some code after executing any of the operations below, you can by adding each of the following hooks to your .bashrc(.zshrc, dotfiles, etc).

-   `checkout`

```bash
# Arguments
# - $1: branch name
# - $2: current path

# Example
zsh_git_fzf_on_checkout() {
    BRANCH_NAME=$1
    if [[ "$BRANCH_NAME" = "master" ]]
    then
        # code
    elif [[ "$BRANCH_NAME" = "dev" ]]
    then
        # code
    fi

    PWD=$2
    PROJECT_NAME_1='project-name-1'
    PROJECT_NAME_2='project-name-2'
    if [[ "$PWD" == *"$PROJECT_NAME_1"* ]]
    then
        # code
    elif [[ "$PWD" == *"$PROJECT_NAME_2"* ]]
    then
        # code
    fi
}
```

-   `worktree`

```bash
# Arguments
# - $1: worktree operation("add", "remove", "list")
# Rest arguments based on the worktree operation
# - "add":
#   - $2: path where worktree created
#   - $3: branch name
# - "remove":
#   - $2: path where worktree deleted
# - "list":
#   - $2: path you switched to
#   - $3: previous worktree path

# Example
zsh_git_fzf_on_worktree_operation() {
    IS_BARE_REPO=$(git rev-parse --is-bare-repository)
    if [ $IS_BARE_REPO = "true" ]; then
        return 1
    fi

    WORKTREE_OPERATION=$1
    if [[ "$WORKTREE_OPERATION" = "list" ]]
    then
        # code
    elif [[ "$WORKTREE_OPERATION" = "add" ]]
    then
        # code
    elif [[ "$WORKTREE_OPERATION" = "remove" ]]
    then
        # code
    fi

    PWD=$2
    PROJECT_NAME_1='project-name-1'
    PROJECT_NAME_2='project-name-2'
    if [[ "$PWD" == *"$PROJECT_NAME_1"* ]]
    then
        # code
    elif [[ "$PWD" == *"$PROJECT_NAME_2"* ]]
    then
        # code
    fi
}
```

## Contribution

-   Reporting a bug
-   Improving this documentation
-   Writing tests
-   Sharing this project and recommending it to your friends
-   Giving a star on this repository
-   [TODO](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/TODO.md)

## License

[MIT © Alexis Zamanidis](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/LICENSE)
