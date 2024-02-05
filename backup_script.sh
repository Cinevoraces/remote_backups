#!/bin/bash

echo "Beginning backup procedure..."

# Settings
service_name="cinevoraces"
distant_directory="/home/ubuntu/cinevoraces_infra/backup"
local_directory="/home/rasbpi/cinevoraces-backups"
max_items=100

# Get the list of remote backups from the SSH output
echo "Recovering distant backups list..."
remote_backups_info=$(ssh $service_name "ls -1t $distant_directory")
IFS=$'\n' read -rd '' -a remote_backups <<<"$remote_backups_info"

# Get the most recent file in the local directory, if it's not empty
most_recent_local=""
if [ -n "$(ls -A $local_directory)" ]; then
  most_recent_local=$(ls $local_directory | grep -oP 'backup_\K[\d-]+\.[\d:]+' | sort -t '_' -k 1,1 | tail -n 1)
  most_recent_local="backup_${most_recent_local}.tar"
fi

# Copy most recent remote_backups that are not stored locally
echo "Copying lastest backups locally..."
for remote_backup in "${remote_backups[@]}"; do
  local_backup="$local_directory/$(basename $remote_backup)"
  if [[ -z "$most_recent_local" || "$remote_backup" > "$most_recent_local" ]]; then
    scp $service_name:$distant_directory/$remote_backup $local_backup
    echo "$remote_backup saved locally."
  else
    echo "$remote_backup is an older backup. Ignored."
  fi
done

# Check the number of items in the local directory
num_items_local=$(ls -1 $local_directory | wc -l)

# Remove the oldest items if there are more than 100 items
if [ $num_items_local -gt $max_items ]; then
  echo "More than $max_items backups, starting oldest backups deletion"
  num_to_remove=$((num_items_local - max_items))
  oldest_backups=$(ls -1t $local_directory | tail -n $num_to_remove)
  for backup_to_remove in $oldest_backups; do
    rm $local_directory/$backup_to_remove
    echo "Removed $backup_to_remove"
  done
fi

echo "Backups procedure achieved."
