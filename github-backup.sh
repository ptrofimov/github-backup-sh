#!/bin/bash

#
# Simple shell script to backup all GitHub repos
# Usage: github-backup.sh -u <repo-user> | -o <repo-org> [--debug] -l <login-user>
# @author Petr Trofimov <petrofimov@yandex.ru>
# @author Federico Mestrone <fmestrone@gmail.com>
#

function echo_usage
{
    echo "Usage: github-backup.sh -u <repo-user>|-o <repo-org> -l <login-user> [--debug]"
}

if [ "$#" -eq 0 ]; then
  echo "No option specified"
  echo_usage
  exit 1
fi

while [[ $# -gt 1 ]]
do
case $1 in
    -o|--org)
    GIT_TARGET="orgs/$2"
    shift
    ;;
    -u|--user)
    GIT_TARGET="users/$2"
    shift
    ;;
    -l|--login-user)
    GIT_USER="$2"
    shift
    ;;
    --debug)
    set -x
    ;;
    *)
    echo "Unknown option $1"
    echo_usage
    exit 1
    ;;
esac
shift
done

if [ "x$GIT_TARGET" = "x" ]; then
  echo "No repo username or organization specified"
  echo_usage
  exit 1
fi

if [ "x$GIT_USER" = "x" ]; then
  echo "No login username specified"
  echo_usage
  exit 1
fi

set -e

GIT_API_URL="https://api.github.com/${GIT_TARGET}/repos?type=all"
GIT_DATE=$(date +"%Y%m%d")
GIT_TEMP_DIR="$(mktemp -q -d -t "github_${GIT_USER}_${GIT_DATE}")"
GIT_BACKUP_FILE="github_${GIT_USER}_${GIT_DATE}.tgz"

echo "Ready to back up all repos from ${GIT_API_URL}"
echo "Temp target folder: $GIT_TEMP_DIR"
echo "Final target file: $GIT_BACKUP_FILE"

pushd "$GIT_TEMP_DIR"

curl -u "$GIT_USER" -s "$GIT_API_URL" | grep -Eo '"clone_url": "[^"]+"' | awk '{print $2}' | xargs -n 1 git clone

popd

tar zcf "$GIT_BACKUP_FILE" "$GIT_TEMP_DIR"
rm -Rf "$GIT_TEMP_DIR"

exit 0
