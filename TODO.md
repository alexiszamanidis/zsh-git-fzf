1. Move back until you find a bare repository + Create a worktree + Run script for setting up the project. We should pass the script by absolute path or assume that it will be in the repository with specific name
2. Remove worktree + prune after deletion
3. Refactor \_bare_repo_fetch method
4. Add installation script for fzf
5. Add Docker and Ansible for testing new machine

**Design**

-   Make this plugin work for bare repositories

Second phase

-   Make this plugin work for non-bare repositories
