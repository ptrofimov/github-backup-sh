# github-backup-sh

*Simple shell script to backup all GitHub repos for the specified user or organization*

Well, there are many solutions, which will not only backup your repositories
but also prepare a pizza for you and clean after itself.
Here is a very simple Bash script to perform this task easily
with few questions in one go. Nothing more.

Just run:

```
./github-backup.sh -u <repo-user> -l <login-user>
```

to get all repositories from user `repo-user` logging into GitHub as `login-user` (you will be prompted for your login password). 

```
./github-backup.sh -o <repo-org> -l <login-user>
```

to get all repositories from organization `repo-org`.

You will get a `tgz` archive of all GitHub repos in your current folder. It's simple!

You can also use the `--debug` option to enable Bash debugging (`set -x`) and use the `-t` option to specify the type of
repositories you want to back up (for a user-based repository, one of `all`, `owner`, or `member`; for an organization,
one of `all`, `public`, `private`, `forks`, `sources`, or `member`). The default type is `all`.

Enjoy!