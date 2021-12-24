1. Move back until you find a bare repository + Create a worktree + Run script for setting up the project. We should pass the script by absolute path or assume that it will be in the repository with specific name
2. Remove worktree + prune after deletion
3. Refactor \_bare_repo_fetch method
4. Add installation script for fzf, vscode
5. Add Docker and Ansible for testing new machine
6. After cloning the repository, maybe the user should run a 'wt setup' for installing all the dependencies(e.g. vscode, fzf)
7. Every time a ZSH shell runs, we need to run a 'git fetch' to check if the user needs to 'git pull' our new features/bug fixes etc

**Design**

-   Make this plugin work for bare repositories

Second phase

-   Make this plugin work for non-bare repositories
