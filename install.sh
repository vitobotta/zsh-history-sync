#!/bin/bash

echo "Please enter the full path to the git repository you want to use for the syncing:"
read GIT_REPO_PATH

echo "Please enter your GPG key UID for encryption:"
read GPG_KEY_UID

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo "export ZSH_HISTORY_SYNC_SCRIPT_PATH=${SCRIPT_DIR}/sync-history.sh" >> ~/.zshrc
echo "export ZSH_HISTORY_SYNC_GIT_REPO_PATH=${GIT_REPO_PATH}" >> ~/.zshrc
echo "export ZSH_HISTORY_SYNC_GPG_KEY_UID=${GPG_KEY_UID}" >> ~/.zshrc
echo source "${SCRIPT_DIR}/zsh.include.sh" >> ~/.zshrc
