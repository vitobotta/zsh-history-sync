#!/bin/bash

echo "Please enter the FULL path of the file to sync:"
read FILE_TO_SYNC

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo ZSH_HISTORY_SYNC_SCRIPT_PATH="${SCRIPT_DIR}/sync-history.sh" >> ~/.zshrc
echo ZSH_HISTORY_SYNC_FILE_PATH="${FILE_TO_SYNC}" >> ~/.zshrc
echo source "${SCRIPT_DIR}/zsh.include.sh" >> ~/.zshrc
