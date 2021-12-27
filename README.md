# zsh-git-worktree

A ZSH plugin that wraps some git worktree operations for simplicity and productivity. Also, it combines the FZF tool to make the git worktree operations more convenient.

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

## References

-   [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
