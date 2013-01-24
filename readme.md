# github-backup-sh

*Simple shell script to backup all GitHub repos for specified user*

Well, there are many solutions, which will not only backup your repositories
but also prepare a pizza for you and clean after itself.
Here it is very simple Bash-written script to do this task easily
without any questions in one go. Nothing more.

Just run:

```sh
github-backup.sh <username>
```

and you will get tgz archive of all GitHub repos. It's simple!

### Use it without any installation

```sh
curl "https://raw.github.com/ptrofimov/github-backup-sh/master/github-backup.sh" | sh -s <username>
```

Enjoy!