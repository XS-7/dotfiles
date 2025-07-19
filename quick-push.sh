#!/bin/bash
set -e  # Exit on any error

cd ~/dotfiles

# Check if there are changes
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

git add .
git commit -m "Auto-sync dotfiles - $(date +"%Y-%m-%d %H:%M")"
git push

echo "✅ Dotfiles synced and pushed!"
