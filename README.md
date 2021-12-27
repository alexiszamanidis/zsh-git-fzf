# zsh-git-worktree

Zsh plugin for git worktrees

## Usage

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
