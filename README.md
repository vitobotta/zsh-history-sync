# zsh-history-sync

Syncs your zsh shell history between computers using git and in encrypted format (using GPG), easily. Only requirement is to have a git repository on Github or similar (recommended private although the history is encrypted).

If you like this or any of my other projects and would like to help with their development, consider [becoming a sponsor](https://github.com/sponsors/vitobotta).

Notes:
- To eliminate or at least minimise the frequency of conflicts, the history is synced only when the last command was executed at least 15 seconds ago. This way even if you switch from a computer to another quickly, the chance of a sync conflict is greatly reduced compared to a sync at each command.
- You can trigger a sync at any time with the command `synchistory -f`
- [fzf](https://github.com/junegunn/fzf) is required to show a nice fuzzy-search window to search the history for a previous command
- Ctrl-r and the up arrow key are bound to the fuzzy search, to make it easier and quicker to find a previous command you want to run again.

## Installation

You need to clone this repo with the scripts somewhere and run the install script. The installer will ask you for the path to your git repository that you want to use to synchronise the history, as well the UID of the GPG key you want to use to encrypt the history. The install script then updates your .zshrc to load what's required to trigger the synchronisation in background.

```bash
git clone https://github.com/vitobotta/zsh-history-sync.git
cd zsh-history-sync

./install.sh

source ~/.zshrc
```
