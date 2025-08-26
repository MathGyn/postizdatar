# Git Workflow Guide for Postiz Self-Hosted

## Repository Information

- **Repository**: Postiz Self-Hosted Setup
- **Main Branch**: `main`
- **Created**: $(date)
- **Initial Commit**: dd622a3

## Basic Git Commands for This Project

### Daily Workflow

```bash
# Check current status
git status

# See what has changed
git diff

# Add files to staging
git add .                    # Add all changes
git add filename.txt         # Add specific file

# Commit changes
git commit -m "Descriptive commit message"

# View commit history
git log --oneline
```

### Configuration Management

```bash
# Update configuration files
git add docker-compose.yml
git commit -m "Update Postiz configuration: increase memory limits"

# Add new environment settings
git add README.md
git commit -m "docs: add network access instructions"
```

### Branching for Features

```bash
# Create and switch to a new branch
git checkout -b feature/add-ssl-support

# Work on your feature, then commit
git add .
git commit -m "feat: add SSL certificate support"

# Switch back to main
git checkout main

# Merge your feature
git merge feature/add-ssl-support

# Delete the feature branch
git branch -d feature/add-ssl-support
```

## Commit Message Conventions

Use descriptive commit messages with prefixes:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation updates
- `config:` - Configuration changes
- `security:` - Security-related changes
- `chore:` - Maintenance tasks

### Examples:
```bash
git commit -m "feat: add backup script for database"
git commit -m "fix: resolve port conflict with existing services"
git commit -m "docs: update installation guide"
git commit -m "config: change Redis memory allocation"
git commit -m "security: update JWT secret rotation"
```

## Important Files in This Repository

- `docker-compose.yml` - Main configuration file
- `README.md` - Setup and usage documentation
- `.gitignore` - Files to exclude from version control
- `test-installation.sh` - Installation verification script

## Security Note

The `docker-compose.yml` file contains your JWT secret. While it's currently tracked in Git, consider:

1. Using environment variables for sensitive data
2. Creating a `.env` file (and adding it to `.gitignore`)
3. Using Docker secrets for production deployments

## Backup Strategy

```bash
# Create a backup branch before major changes
git checkout -b backup/before-major-update
git checkout main

# After testing, you can delete the backup
git branch -d backup/before-major-update
```

## Remote Repository Setup

If you want to push this to GitHub/GitLab:

```bash
# Add remote repository
git remote add origin https://github.com/yourusername/postiz-selfhost.git

# Push to remote
git push -u origin main

# Future pushes
git push
```

## Useful Git Aliases

Add these to your Git configuration for easier workflow:

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `git status` | Check working directory status |
| `git add .` | Stage all changes |
| `git commit -m "message"` | Commit with message |
| `git log --oneline` | View commit history |
| `git diff` | See unstaged changes |
| `git diff --cached` | See staged changes |
| `git checkout -- filename` | Discard changes to file |
| `git reset HEAD filename` | Unstage file |
