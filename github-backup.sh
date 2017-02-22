#!/bin/bash

#
# Simple shell script to backup all GitHub repos
# Usage: github-backup.sh -u <repo-user> | -o <repo-org> [--debug] -l <login-user>
# @author Petr Trofimov <petrofimov@yandex.ru>
# @author Federico Mestrone <fmestrone@gmail.com>
#

function echo_usage
{
    echo
    echo "Usage:"
    echo "github-backup.sh -u <repo-user>|-o <repo-org> -l <login-user> [-t all|public|private|forks|sources|owner|member] [--debug]"
    echo "github-backup.sh --user <repo-user>|--org <repo-org> --login <login-user> [--type all|public|private|forks|sources|owner|member] [--debug]"
    echo
}

echo

if [ "$#" -eq 0 ]; then
  echo "No option specified"
  echo_usage
  exit 1
fi

GIT_TYPE="all"

while [[ $# -gt 0 ]]
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
    -l|--login)
    GIT_USER="$2"
    shift
    ;;
    -t|--type)
    GIT_TYPE="$2"
    shift
    ;;
    --debug)
    echo "Enabling debug mode"
    echo
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

GIT_API_URL="https://api.github.com/${GIT_TARGET}/repos?type=${GIT_TYPE}"
GIT_DATE=$(date +"%Y%m%d")
GIT_TEMP_DIR="$(mktemp -q -d -t "github_${GIT_USER}_${GIT_DATE}")"
GIT_BACKUP_FILE="github_${GIT_USER}_${GIT_DATE}.tgz"

echo "Ready to back up $GIT_TYPE repos from ${GIT_API_URL}"
echo
echo "Temp target folder: $GIT_TEMP_DIR"
echo "Final target file: $GIT_BACKUP_FILE"
echo

echo "CDing into target folder $GIT_TEMP_DIR"
echo
pushd "$GIT_TEMP_DIR" > /dev/null

echo "Cloning $GIT_TYPE repos"
echo
curl -u "$GIT_USER" -s "$GIT_API_URL" | grep -Eo '"clone_url": "[^"]+"' | awk '{print $2}' | xargs -n 1 git clone

echo "Returning to initial folder"
echo
popd > /dev/null

echo "Creating target file $GIT_BACKUP_FILE"
echo

tar czf "$GIT_BACKUP_FILE" -C "$GIT_TEMP_DIR/.." $(basename "$GIT_TEMP_DIR")
ls -l "$GIT_BACKUP_FILE"

echo "Deleting target folder $GIT_TEMP_DIR"
echo
rm -Rf "$GIT_TEMP_DIR"

exit 0
