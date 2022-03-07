# zsh-git-fzf

A ZSH plugin that wraps git operations for simplicity and productivity. Also, it **contains completions** and **combines the FZF** tool to make the operations more convenient.

**You can find my plugin listed among other useful plugin in the [awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) repository!**

### Benefits

-   Interactive
-   Simplicity and Productivity
-   Plugin completions. After typing `git-fzf `, `gfzf ` or `gf `, press `TAB` to view the completions ([Demo](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/DEMO.md#completions))
-   git worktree
    -   Simpler API
    -   No need to `cd` around. After you have created a git worktree you will be moved into it
    -   Easy setup for your project after you create an installation script named `install` in the root folder of the repository
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

# Usage

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

    -   Checkout new branch from a **remote branch**:
        -   Run the following command: `git-fzf worktree add [new-branch] [remote-branch(optional)]`
        -   After executing the command above, you will be moved into the new working tree
    -   Checkout **remote branch**:
        -   Run the following command: `git-fzf worktree add [remote-branch]`
        -   After executing the command above, close the fzf by pressing `ESC` and you will be moved into the new working tree
    -   Checkout new branch from a **local branch**:

        -   Run the following command: `git-fzf worktree add [new-branch]`
        -   After executing the command above, select a working tree from the fzf results and you will be moved into the new working tree

    **remove**

    -   Remove a worktree
        -   Run the following command: `git-fzf worktree remove`
        -   After executing the command above, select a working tree from the fzf results and the selected worktree will be removed

    **list**

    -   List all worktrees
        -   Run the following command: `git-fzf worktree list`
        -   After executing the command above, close the fzf by pressing `ESC`
    -   Switch worktree
        -   Run the following command: `git-fzf worktree list`
        -   After executing the command above, select a working tree from the fzf results and you will be moved into the selected working tree

    **clean**

    -   Removes all working trees that do not have a corresponding remote repository

## Assumptions

This is the first version of the plugin, so you need to make some assumptions to use it

-   Make sure your working repository is bare

```
git clone --bare [your-repository]
```

-   If you want to execute a project set-up script after creating a new work tree, you need to add it to your repository as 'install'.

```
you-repository-folder/
- install
```

## Contribution

-   Reporting a bug
-   Improving this documentation
-   Writing tests
-   Sharing this project and recommending it to your friends
-   Giving a star on this repository

## License

[MIT © Alexis Zamanidis](https://github.com/alexiszamanidis/zsh-git-fzf/blob/master/LICENSE)
