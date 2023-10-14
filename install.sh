#!/bin/bash

FILE_TO_SYNC=$1

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo ZSH_HISTORY_SYNC_SCRIPT_PATH="${SCRIPT_DIR}/sync-history.sh" >> ~/.zshrc
echo ZSH_HISTORY_SYNC_FILE_PATH="${FILE_TO_SYNC}" >> ~/.zshrc
echo source "${SCRIPT_DIR}/zsh.include.sh" >> ~/.zshrc
