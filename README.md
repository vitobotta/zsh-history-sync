# zsh-history-sync

Syncs your zsh shell history between computers, easily. Only requirements is to have Dropbox, Nextcloud or similar sync software.

Notes:
- To eliminate or at least minimise the frequency of conflicts, the history is synced every 30 seconds.
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




