# zsh-worktree

Zsh plugin for git worktrees

## Usage

1. Clone Repository into oh-my-zsh plugins

```
git clone https://github.com/alexiszamanidis/zsh-worktree.git ~/.oh-my-zsh/custom/plugins/zsh-worktree
```

2.  Add plugin to plugin list

-   Open .zshrc(e.g. code .zshrc, vim .zshrc)
-   Add plugin to plugin list

```
plugins=(zsh-worktree)
```

## Requirements for running the plugin

-   fzf

There is a ansible task for installing the fzf tool. Also you will need

## Test Plugin

You need to execute the following commands:

1. Clone the repository
2. Move into the repository
3. Run docker

```
git clone https://github.com/alexiszamanidis/zsh-worktree.git
cd zsh-worktree
./docker
```

After running the commands above you will need to clone a bare repository

Example

```
git clone --bare <your-demo-git-repository>
cd <your-demo-git-repository>
```

After cloning the bare repository you will able to try the plugin and see if it suits you!
