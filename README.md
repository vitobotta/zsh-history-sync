# zsh-history-sync

Syncs your zsh shell history between computers, easily. Only requirement is to have Dropbox, Nextcloud or similar sync software.

Notes:
- To eliminate or at least minimise the frequency of conflicts, the history is synced only when the last command was executed at least 30 seconds ago. This way even if you switch from a computer to another quickly, the chance of a sync conflict is greatly reduced compared to a sync at each command.
- You can trigger a sync at any time with the command `synchistory -f`
- [fzf](https://github.com/junegunn/fzf) is required to show a nice fuzzy-search window to search the history for a previous command
- Ctrl-r and the arrow key are bound to the fuzzy search, to make it easier and quicker to find a previous command you want to run again.

## Installation

You need to clone the repo with the scripts somewhere and run the install script. The install script accepts a single argument for the path of the file to keep in sync in your Dropbox or equivalent synced directory.

```bash
git clone https://github.com/vitobotta/zsh-history-sync.git
cd zsh-history-sync

./install.sh <path of synced file on dropbox or equivalent, e.g. /Users/vito/Dropbox/zsh_history>

source ~/.zshrc
```

Since sync is triggered only if the previous command ran at least 30 seconds ago, some commands might be left unsynced when you switch to the other computer. To fix this you can also schedule a sync every minute with an offset on the second computer, so to minimise the risk of sync conflicts. Using crontab, on the first computer:

```
* * * * * /path/of/zsh-history-sync/sync-history.sh /path/of/synced/file
```

On the second computer:

```
* * * * * sleep 30; /path/of/zsh-history-sync/sync-history.sh /path/of/synced/file
```





