# zsh-git-worktree

A ZSH plugin that wraps some git worktree operations for simplicity and productivity. Also, it combines the FZF tool to make the git worktree operations more convenient.

**You can find my plugin listed among other useful plugin in the [awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) plugin!**

## Benefits

-   Simpler API for git worktrees
-   No need to `cd` around. After you have created a git worktree you will be moved into it
-   Easy setup for your project after you create an installation script named `install` in the root folder of the repository
-   You will never stash your changes again

## Dependencies

-   Git version: 2.34.1
-   [fzf](https://github.com/junegunn/fzf): This tool will be installed by the installation script

## Installation

1. Install Plugin

```
wget -q https://raw.githubusercontent.com/alexiszamanidis/zsh-git-worktree/main/install -O install && \
chmod +x install && \
./install && \
rm -rf ./install
```

2.  Add plugin to plugin list

-   Open .zshrc(e.g. code .zshrc, vim .zshrc)
-   Add plugin to plugin list

```
plugins=(zsh-git-worktree)
```

## Usage

After installing the plugin you can execute **wt help** to check the operations that are provided:

```
Usage:
    wt list: List details of each working tree
    wt prune: Prune working tree information
    wt fetch: Fetch branches from the bare repository
    wt add <worktree-name> <(optional-)remote-worktree-name>: Create new working tree
    wt remove: Remove a working tree
    wt upgrade: Upgrade zsh-git-worktree plugin
```

**wt add** (Create Operation)

-   Checkout new branch from a **remote branch**:
    -   Run the following command: `wt add <-new-branch-> <-remote-branch->`
-   Checkout **remote branch**:
    -   Run the following command: `wt add <-remote-branch->`
    -   After executing the command above, close the fzf by pressing ESC
-   Checkout new branch from a **local branch**:
    -   Run the following command: `wt add <-new-branch->`
    -   After executing the command above, select a working tree from the fzf results

## Assumptions

This is the first version of the plugin, so you need to make some assumptions to use it

-   Make sure your working repository is bare

```
git clone --bare <your-repository>
```

-   If you want to execute a project set-up script after creating a new work tree, you need to add it to your repository as 'install'.

```
you-repository-folder/
- install
```

## Demo

![zsh-git-worktree](https://user-images.githubusercontent.com/48658768/147582012-636af175-f296-44c7-b412-8e55117b7931.gif)

## Contribution

If you have an idea that fits this plugin or have solved any of my TODOs, follow these steps:

-   Fork the repository
-   Create new branch
-   Open a pull request

If you found anything unusual please create an issue.

## References

-   [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
