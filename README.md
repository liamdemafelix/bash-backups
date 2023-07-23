# Bash Backups

A simple backup wrapper for Restic that backs up my personal server. Use at your own risk.

## Environment

You need `restic` installed. Additionally, this script takes care of backing up a Nextcloud instance. Modify this script yourself if you do not need this.

## Usage

* Create `/etc/backups` (`mkdir /etc/backups`)
* Copy `env.sh`, `exclusions.conf` and `structure.conf` to `/etc/backups`
* Edit `env.sh` based off of your requirements
  * This wrapper uses IDrive e2. See the [restic docs](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html) for other backends.
  * Your `env.sh` config must have an already-initialized repo. This wrapper will not do this for you.
* Copy `run.sh` to `/usr/local/bin` and give it execute permissions (`chmod +x /usr/local/bin/run.sh`)

Then, schedule `/usr/local/bin/run.sh` to execute via cron at the intervals of your choice. To ensure that everything works properly, run it manually the first time via `run.sh`.

## Disclaimer

Use this at your own risk. Always test your backups.