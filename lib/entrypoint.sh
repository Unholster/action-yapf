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

yapf --recursive -i  --style='{ \
based_on_style: pep8, \
BLANK_LINE_BEFORE_NESTED_CLASS_OR_DEF: True, \
BLANK_LINES_AROUND_TOP_LEVEL_DEFINITION: 2, \
COLUMN_LIMIT: 100, \
EACH_DICT_ENTRY_ON_SEPARATE_LINE: False, \
SPLIT_ALL_TOP_LEVEL_COMMA_SEPARATED_VALUES: True, \
SPLIT_BEFORE_ARITHMETIC_OPERATOR: True, \
SPLIT_BEFORE_CLOSING_BRACKET: True \
SPLIT_BEFORE_DOT: True, \
SPLIT_BEFORE_FIRST_ARGUMENT: True, \
SPLIT_BEFORE_LOGICAL_OPERATOR: True, \
SPLIT_COMPLEX_COMPREHENSION: true, \
DEDENT_CLOSING_BRACKETS: true
}' \
--exclude '*/migrations/*.py' \
--exclude '*_settings.py' \
--exclude '*/settings.py' \
--exclude '*/manage.py' \
--exclude 'celery.py' \
--exclude '__init__.py' \
.

# Delay the comment to regroup the commits
if ! git diff-index --quiet HEAD --; then CHANGES=true ; fi

git config --local user.name "Yapf Code Formatter BOT"
git config --local user.email foo@bar.com

git add .

# force exit successfully
git commit -m "Yapf Automatically Formatted Code" || true

git push -u origin $BRANCH

if [ "$CHANGES" = true ] ; then python3 /lib/comment_pr.py ; fi
