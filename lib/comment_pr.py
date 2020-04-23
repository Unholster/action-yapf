import os

from github import Github

github_token = os.environ['GITHUB_TOKEN']
github_repository = os.environ['GITHUB_REPOSITORY']
pr_number = os.environ['GITHUB_REF'].split('/')[2]

g = Github(github_token)
repo = g.get_repo(github_repository)
pr = repo.get_pull(int(pr_number))
pr.create_issue_comment('`Yapf` has formatted your code and committed this changes.')
