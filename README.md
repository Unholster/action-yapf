# action-yapf

This Github Action performs a code reformatting using yapf on Pull requests. If a commit contains non-yapf formatted code, it will automatically run yapf and warn the user to do it beforehand.

![Screenshot](https://github.com/Unholster/action-yapf/blob/master/Screenshot.png)

## Usage

In `/.github/workflows/example.yaml`
```
name: Yapf Formatter
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  build:
    name: Yapf Code Formatter
    runs-on: ubuntu-latest
    steps:
    - name: Yapf Code Formatter
      uses: Unholster/action-yapf@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} 
```
