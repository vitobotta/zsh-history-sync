#!/bin/zsh

home=$HOME
source_file="${home}/.zsh_history"
sync_file=$1
last_command_timestamp_file="${HOME}/.zsh-last-sync"
force_sync=$2
identifier=$(hostname)
repo_dir=$(dirname $sync_file)

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

write_file() {
  echo -e "$2" > $1
}

current_time=$(date +%s)
last_executed_time=$(cat $last_command_timestamp_file 2>/dev/null || echo 0)

if (( current_time - last_executed_time >= 15 )) || [ "$force_sync" = "-f" ]; then
  {
    git -C $repo_dir pull > /dev/null 2>&1

    source_items=$(read_file $source_file)
    new_items=$(read_file $sync_file)
    items=$(echo -e "$source_items\n$new_items" | sort | uniq)

    write_file $source_file "$items"
    write_file $sync_file "$items"

    fc -R $source_file

    echo $current_time > $last_command_timestamp_file

    git -C $repo_dir add $sync_file
    git -C $repo_dir commit -m "Sync history from $identifier" > /dev/null 2>&1
    git -C $repo_dir push > /dev/null 2>&1
  } &
fi

