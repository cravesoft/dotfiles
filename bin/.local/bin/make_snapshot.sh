#!/bin/bash

SOURCE_PATH="$1"
DESTINATION_PATH="$2"

# Check that destination path is valid
if [ ! -e "$DESTINATION_PATH" ]
then
    echo "Error, destination path is not valid"
    exit
fi

rsync -apv --progress --del --stats --times --perms --filter "- *.tmp" --filter "- *.iso" --filter "- lost+found/" "$SOURCE_PATH" "$DESTINATION_PATH"

echo "Done."
