-   Move back until you find a bare repository + Create a worktree + Run script for setting up the project. We should pass the script by absolute path or assume that it will be in the repository with specific name
-   Refactor \_bare_repo_fetch method. I only need to set the config once
-   Every time a ZSH shell runs, we need to run a 'git fetch' to check if the user needs to 'git pull' our new features/bug fixes etc
-   Add editor for opening the worktrees(\_wt_add has already the implementation for the editor commented out). We need to get the editor information from the .zshrc file. **Clean up current implementation**
-   Problem with the installation of the dependencies(e.g. node_modules). Should I include 'npm/yarn install' in the installation script? Is there a way to copy fast the node_modules(e.g. file links? - if I change a dependency with a hard link all the dependencies will be changed)?
-   Should a bare repository be a convention for this plugin? Then, we need to refactor the `_move_to_bare_repo` method, because we can pick up the bare repo path from the command: `git worktree list | fzf`

**Design**

-   Make this plugin work for bare repositories
-   Comment out current editor implementation
-   Run script with specific name in the working tree

Second phase

-   Make this plugin work for non-bare repositories
-   Stable Editor implementation
-   Pass script as an argument. This script will be executed after the creation of the working tree.
