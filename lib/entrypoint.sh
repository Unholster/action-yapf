#!/bin/bash
set -e

if ! git status > /dev/null 2>&1 ; then git init ; fi

REMOTE_TOKEN_URL="https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
if ! git remote | grep "origin" > /dev/null 2>&1
then 
  echo "### Adding git remote..."
  git remote add origin $REMOTE_TOKEN_URL
  git fetch
fi

git remote set-url --push origin $REMOTE_TOKEN_URL

BRANCH="$GITHUB_HEAD_REF"
echo "### Branch: $BRANCH"
git checkout $BRANCH

yapf

# Delay the comment to regroup the commits
if ! git diff-index --quiet HEAD --; then CHANGES=true ; fi

git config --local user.name "Yapf Code Formatter BOT"
git config --local user.email foo@bar.com

git add .

# force exit successfully
git commit -m "Yapf Automatically Formatted Code" || true

git push -u origin $BRANCH

if [ "$CHANGES" = true ] ; then python3 /lib/comment_pr.py ; fi
