# github-backup-sh

Simple shell script to backup all GitHub repos for specified user.

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