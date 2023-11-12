#!/usr/bin/env zsh

lockfile=/tmp/mylockfile

if [ -e ${lockfile} ] && kill -0 `cat ${lockfile}`; then
  echo "already running"
  exit
fi

trap "rm -f ${lockfile}; exit" INT TERM EXIT
echo $$ > ${lockfile}

set -e

home="$HOME"
repo_dir="$1"
force_sync="$2"
source_file="${home}/.zsh_history"
sync_file="${repo_dir}/zsh_history.enc"
last_command_timestamp_file="${HOME}/.zsh-history-sync.last-sync"
encryption_key_file="${HOME}/.zsh-history-sync.encryption-key"
identifier="$(hostname)"

ZSH_HISTORY_SYNC_GPG_KEY_UID="${ZSH_HISTORY_SYNC_GPG_KEY_UID:-}"

read_file() {
  if [ ! -f $1 ]; then
    echo "$1 doesn't exist, creating..."
    touch $1
  fi
  cat $1 | while read command; do
    if [[ $command == :* ]]; then
      echo "$command"
    else
      echo ": $command"
    fi
  done
}

GPG_CMD=$(which gpg)

if [[ -z "$GPG_CMD" ]]; then
  echo "No GPG binary found."
  exit 1
fi

if [[ -z "$ZSH_HISTORY_SYNC_GPG_KEY_UID" ]]; then
  echo "No GPG key UID specified."
  exit 1
fi

current_time=$(date +%s)
last_executed_time=$(cat $last_command_timestamp_file 2>/dev/null || echo 0)

if (( current_time - last_executed_time >= 30 )) || [ "$force_sync" = "-f" ]; then
  {
    git -C $repo_dir reset --hard > /dev/null 2>&1
    git -C $repo_dir fetch > /dev/null 2>&1
    git -C $repo_dir merge -X theirs -m "Merging fetched changes" > /dev/null 2>&1

    new_items=""

    if [[ -f $sync_file ]]; then
      temp_sync_file=$(mktemp)
      $GPG_CMD --decrypt "$sync_file" > "$temp_sync_file" 2>/dev/null
      new_items=$(read_file "$temp_sync_file")
      rm "$temp_sync_file"
    fi

    source_items=$(read_file $source_file)
    items=$(echo -e "$new_items\n$source_items" | grep -v '^\:\s[<=>]\{3\}' | awk '!x[$0]++')

    echo -e "$items" > $source_file
    echo -e "$items" | $GPG_CMD --encrypt --trust-model always --yes  --recipient "$ZSH_HISTORY_SYNC_GPG_KEY_UID" --output "$sync_file" 2>/dev/null

    fc -R $source_file

    git -C $repo_dir add $sync_file > /dev/null 2>&1
    git -C $repo_dir commit -m "Sync history from $identifier" > /dev/null 2>&1
    git -C $repo_dir push > /dev/null 2>&1

    current_time=$(date +%s)
    echo $current_time > $last_command_timestamp_file
  } &
fi

rm -f ${lockfile}
