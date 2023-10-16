#!/bin/bash

echo "Please enter the full path to the git repository you want to use for the syncing:"
read GIT_REPO_PATH

echo "Please enter the password to use for encryption:"
read -s ENCRYPTION_PASSWORD

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo "export ZSH_HISTORY_SYNC_SCRIPT_PATH=${SCRIPT_DIR}/sync-history.sh" >> ~/.zshrc
echo "export ZSH_HISTORY_SYNC_GIT_REPO_PATH=${GIT_REPO_PATH}" >> ~/.zshrc
echo "${ENCRYPTION_PASSWORD}" > ${HOME}/.zsh-history-sync.encryption-key
echo source "${SCRIPT_DIR}/zsh.include.sh" >> ~/.zshrc
