# zsh-history-sync

Syncs your zsh shell history between computers using git and in encrypted format (using openssl), easily. Only requirement is to have a git repository on Github or similar (recommended private although the history is encrypted).

Notes:
- To eliminate or at least minimise the frequency of conflicts, the history is synced only when the last command was executed at least 15 seconds ago. This way even if you switch from a computer to another quickly, the chance of a sync conflict is greatly reduced compared to a sync at each command.
- You can trigger a sync at any time with the command `synchistory -f`
- [fzf](https://github.com/junegunn/fzf) is required to show a nice fuzzy-search window to search the history for a previous command
- Ctrl-r and the up arrow key are bound to the fuzzy search, to make it easier and quicker to find a previous command you want to run again.

## Installation

You need to clone this repo with the scripts somewhere and run the install script. The installer will ask you for the path to your git repository that you want to use to synchronise the history, as well as a password to encrypt it (the password will be stored in ~/.zsh-history-sync.encryption-key). The install script then updates your .zshrc to load what's required to trigger the synchronisation in background.

```bash
git clone https://github.com/vitobotta/zsh-history-sync.git
cd zsh-history-sync

./install.sh

source ~/.zshrc
```

I recommend you also schedule a sync every minute (just to ensure every command is synced since the automatic sync depends on when the last command was executed). It's better to specify an offset on the second computer, so to minimise the risk of sync conflicts. Using crontab, on the first computer:

```
* * * * * /path/to/zsh-history-sync/sync-history.sh /path/to/your/repo
```

On the second computer:

```
* * * * * sleep 30; /path/to/zsh-history-sync/sync-history.sh /path/to/your/repo
```





