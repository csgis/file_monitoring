#!/usr/bin/bash


# Usage
#
# Call the script with the directory you want to watch as an argument. e.g.:
# filemonitor.sh /app/foo/
#
#
# Description:
# Uses inotifywait to look for new files in a directory and process them:
# inotifywait outputs data which is passed (piped) to a do for subcommands.
#
#
# Requirements:
# Requires inotifywait which is part of inotify-tools.
# e.g. yum install -y inotify-tools or apt-get install -y inotify-tools.
#
#
# Increase numer of watchers:
# sysctl fs.inotify.max_user_watches
# sysctl -n -w fs.inotify.max_user_watches=16384
#
# --format:
#   %T  Replaced with the current Time in the format specified by the --timefmt option, which should be a format string suitable for passing to strftime(3).
#   %w  This will be replaced with the name of the Watched file on which an event occurred.
#   %f  When an event occurs within a directory, this will be replaced with the name of the File which caused the event to occur. Otherwise, this will be replaced with an empty string.
#   %e  Replaced with the Event(s) which occurred, comma-separated.
#   %Xe Replaced with the Event(s) which occurred, separated by whichever character is in the place of 'X'.
#
# There's no --include option, but there's --exclude, which can be used to the same effect as an include.
#
# test the script by creating a file in the watched directory, e.g.
# touch /app/foo/file1.wav # will trigger the script
# touch /app/foo/file1.txt # will not trigger the script
#
# See also:
# https://linux.die.net/man/1/inotifywait
# https://github.com/inotify-tools/inotify-tools/wiki#info
# (Might be interested in pyinotify too.)

echo "Watch $1 for file changes..."

# FUNCTIONS #
is_dir(){
  if [[ $1 == *"ISDIR"* ]]
  then
    true
  else
    false
  fi
}

deleted_file() {
  echo "$1 was deleted"
}

# SCRIPT #
inotifywait \
  $1 \
  --monitor \
  -e create \
  -e modify \
  -e moved_to \
  -e delete \
  -r \
  --timefmt '%Y-%m-%dT%H:%M:%S' \
  --format '%T %w %f %e' \
| while read datetime dir filename event; do
  echo "Event: $datetime $dir$file $event"
  echo "Datetime: $datetime"
  echo "Dir: $dir"
  echo "Filename $filename"
  echo "Extension:" ${filename##*.}
  echo "Event: $event"

  if is_dir $event; then echo "is directory"; else echo "no directory"; fi

  if [ "$event" = "DELETE" ]; then
      deleted_file $filename
  fi

  # Run command
  # python3 /app/something.py --custom $dir$filename $dir${filename%.*}.txt /tmp/${filename%.*}
done
