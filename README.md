# GitHub vs PyPI: Diff Checker

## Fetch and Diff Script
This script fetches the latest or a specified version of the source code from a GitHub repository and a PyPI package, unpacks the files, and performs a diff check on a specified directory within the source files.

## Prerequisites
Make sure you have the following installed on your system:
- `jq`
- `curl`
- `tar`


### Script Installation
1. Clone the repo
2. Make the script executable

```bash
cd ~
git clone https://github.com/sirouk/git-pypi-checker
cd ./git-pypi-checker
chmod +x fetch_and_diff.sh
```

### Running the Script
Run the script with the GitHub organization, repository name, PyPI repository name, and an optional version as arguments:

```bash
./fetch_and_diff.sh <github_org> <github_repo> <pypi_repo> [version]
```

- `<github_org>`: The GitHub organization name.
- `<github_repo>`: The GitHub repository name.
- `<pypi_repo>`: The PyPI package name.
- `[version]` (optional): The version to fetch. If not provided, the script will fetch the latest release.


### Examples
1. To fetch the latest release from both GitHub and PyPI:

Latest example:
```bash
./fetch_and_diff.sh myorg myrepo mypackage 1.2.3
```

2. Version specific releases:

No diff example:
```bash
./fetch_and_diff.sh opentensor bittensor bittensor 7.2.0
```

Diff example:
```bash
./fetch_and_diff.sh opentensor bittensor bittensor 6.12.2
```

### Output

The script will output the following information:
1. A summary of the GitHub and PyPI sources fetched.
2. The results of the diff check on the specified GitHub repo source directory.

If there are no differences between the sources, it will output a message indicating that no differences were found.
