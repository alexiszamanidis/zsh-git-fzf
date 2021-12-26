1. Move back until you find a bare repository + Create a worktree + Run script for setting up the project. We should pass the script by absolute path or assume that it will be in the repository with specific name
2. Remove worktree + prune after deletion
3. Refactor \_bare_repo_fetch method
4. Add installation script for fzf
5. After cloning the repository, maybe the user should run a 'wt setup' for installing all the dependencies(e.g. fzf)
6. Every time a ZSH shell runs, we need to run a 'git fetch' to check if the user needs to 'git pull' our new features/bug fixes etc
7. Add editor for opening the worktrees. We need to get the editor information from the .zshrc file. **Clean up current implementation**

**Design**

-   Make this plugin work for bare repositories
-   Comment out current editor implementation
-   Run script with specific name in the working tree

Second phase

-   Make this plugin work for non-bare repositories
-   Stable Editor implementation
-   Pass script as an argument. This script will be executed after the creation of the working tree.
