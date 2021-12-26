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

## Test Plugin

You need to execute the following commands:

1. Clone the repository
2. Move into the repository
3. Run docker

```
git clone https://github.com/alexiszamanidis/zsh-git-worktree.git
cd zsh-git-worktree
./docker
```

After running the commands above you will need to clone a bare repository

Example

```
git clone --bare <your-demo-git-repository>
cd <your-demo-git-repository>
```

After cloning the bare repository you will able to try the plugin and see if it suits you!
