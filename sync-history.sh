#!/bin/zsh

home=$HOME
source_file="${home}/.zsh_history"
sync_file=$1
force_sync=$2

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
last_executed_time=$(cat ~/.last_executed_time 2>/dev/null || echo 0)

if (( current_time - last_executed_time >= 30 )) || [ "$force_sync" = "-f" ]; then
  source_items=$(read_file $source_file)
  new_items=$(read_file $sync_file)
  items=$(echo -e "$source_items\n$new_items" | sort | uniq)

  write_file $source_file "$items"
  write_file $sync_file "$items"

  fc -R

  echo $current_time > ~/.last_executed_time
  echo $(date) >> ~/synchistory.log
fi


