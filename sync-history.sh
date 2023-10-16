#!/usr/bin/env zsh

home="$HOME"
repo_dir="$1"
force_sync="$2"
source_file="${home}/.zsh_history"
sync_file="${repo_dir}/zsh_history.enc"
last_command_timestamp_file="${HOME}/.zsh-history-sync.last-sync"
encryption_key_file="${HOME}/.zsh-history-sync.encryption-key"
identifier="$(hostname)"

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

current_time=$(date +%s)
last_executed_time=$(cat $last_command_timestamp_file 2>/dev/null || echo 0)

if (( current_time - last_executed_time >= 15 )) || [ "$force_sync" = "-f" ]; then
  {
    git -C $repo_dir pull > /dev/null 2>&1

    if [[ -f $sync_file ]]; then
      temp_sync_file=$(mktemp)
      openssl enc -aes-256-cbc -md sha256 -d -in "$sync_file" -out "$temp_sync_file" -pass file:"$encryption_key_file" -pbkdf2
      new_items=$(read_file "$temp_sync_file")
      rm "$temp_sync_file"
    else
      new_items=""
    fi

    source_items=$(read_file $source_file)
    items=$(echo -e "$source_items\n$new_items" | sort | uniq)

    echo -e "$items" > $source_file
    echo -e "$items" | openssl enc -aes-256-cbc -md sha256 -out "$sync_file" -pass file:"$encryption_key_file" -pbkdf2

    fc -R $source_file

    echo $current_time > $last_command_timestamp_file

    git -C $repo_dir add $sync_file
    git -C $repo_dir commit -m "Sync history from $identifier" > /dev/null 2>&1
    git -C $repo_dir push > /dev/null 2>&1
  } &
fi
