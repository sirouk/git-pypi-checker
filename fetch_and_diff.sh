#!/bin/bash

# requirements
sudo apt install -y jq curl tar

# remove any previous runs
rm -rf github_source pypi_source github_*.tar.gz pypi_*.tar.gz

# Function to fetch the specified or latest release from GitHub
fetch_github_release() {
  local org=$1
  local repo=$2
  local version=$3
  
  local release_url
  if [ "$version" = "latest" ]; then
    release_url=$(curl -s "https://api.github.com/repos/$org/$repo/releases/latest" | grep tarball_url | cut -d '"' -f 4)
  else
    release_url=$(curl -s "https://api.github.com/repos/$org/$repo/releases/tags/v$version" | grep tarball_url | cut -d '"' -f 4)
  fi
  
  if [ -z "$release_url" ]; then
    echo "Failed to fetch GitHub release URL."
    exit 1
  fi
  
  local github_tarball="github_${version}.tar.gz"
  curl -L -o $github_tarball $release_url
  mkdir -p github_source
  tar -xzf $github_tarball -C github_source --strip-components=1 > /dev/null 2>&1
}

# Function to fetch the specified or latest source from PyPI
fetch_pypi_source() {
  local package=$1
  local version=$2
  
  local release_url
  if [ "$version" = "latest" ]; then
    release_url=$(curl -s "https://pypi.org/pypi/$package/json" | jq -r '.urls[] | select(.packagetype=="sdist") | .url')
  else
    release_url=$(curl -s "https://pypi.org/pypi/$package/$version/json" | jq -r '.urls[] | select(.packagetype=="sdist") | .url')
  fi
  
  if [ -z "$release_url" ]; then
    echo "Failed to fetch PyPI release URL."
    exit 1
  fi
  
  local pypi_tarball="pypi_${version}.tar.gz"
  curl -L -o $pypi_tarball $release_url
  mkdir -p pypi_source
  tar -xzf $pypi_tarball -C pypi_source --strip-components=1 > /dev/null 2>&1
}

# Function to perform a diff check on the specified directory
perform_diff_check() {
  local dir=$1
  local diff_output
  diff_output=$(diff -r "github_source/$dir" "pypi_source/$dir")

  if [ -z "$diff_output" ]; then
    echo "No differences found between the GitHub and PyPI sources for the '$dir' directory."
  else
    echo "$diff_output"
  fi
}

# Main script
main() {
  if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <github_org> <github_repo> <pypi_repo> [version]"
    exit 1
  fi
  
  local github_org=$1
  local github_repo=$2
  local pypi_repo=$3
  local version=${4:-latest}
  
  echo "Fetching GitHub release from $github_org/$github_repo (version: $version)"
  fetch_github_release $github_org $github_repo $version
  
  echo "Fetching PyPI source for $pypi_repo (version: $version)"
  fetch_pypi_source $pypi_repo $version
  
  echo "Performing diff check on the 'bittensor' directory"
  perform_diff_check "bittensor"
}

main "$@"