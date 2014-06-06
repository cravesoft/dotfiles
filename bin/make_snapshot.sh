#!/bin/bash
SOURCE_PATH="/home/boule"
DESTINATION_PATH="/media/boule/WDPassport/home"
  
# Check that destination path is valid
if [ ! -e "$DESTINATION_PATH" ]
then
    echo "Error, destination path is not valid"
    exit
fi
        
rsync -apv --progress --delete --stats --times --perms --filter "- *.tmp" --filter "- *.iso" --filter "- lost+found/" "$SOURCE_PATH" "$DESTINATION_PATH"
          
echo "Done."
