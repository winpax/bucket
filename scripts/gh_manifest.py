"""Generate a manifest file from a Github Repo."""

from sys import argv
from urllib import parse
import hashlib
import requests
from github import Github

gh = Github()

args = argv.copy()
# Remove the script name
args.pop(0)

repo_url = parse.urlparse(args.pop(0))
repo_path = repo_url.path

repo_name = "/".join(repo_path.split("/")[1:3])
repo_asset = repo_path.split("/")[-1]

repo = gh.get_repo(repo_name)

latest_release = repo.get_releases()[0]

dl_url = f"https://github.com/{repo_name}/releases/download/{latest_release.title}/dl-x86_64.7z"

latest_version = latest_release.title.replace("v", "")

content = requests.get(dl_url, timeout=60).content

readable_hash = hashlib.sha256(content).hexdigest()

json_manifest = {
    "$schema": "https://raw.githubusercontent.com/ScoopInstaller/Scoop/master/schema.json",
    "description": repo.description,
    "version": latest_version,
    "hash": readable_hash,
    "url": dl_url,
}

print(json_manifest)
