#!/bin/bash

DIR=$1
TIMESPAN=$2
PHOTO_FOLDER="$HOME/photos"

# Check if photo folder exists
if [ ! -d "$PHOTO_FOLDER" ] 
then
    mkdir $PHOTO_FOLDER
fi

# Check if given directory exists
if [ -d "$DIR" ] 
then
    # Check if folder is not empty
    if [ "$(ls -A $DIR)" ] 
    then
        # Go in folder directory
        cd "$DIR"
    else
        echo "No files exists in this directory"
        exit 1
    fi
else
    echo "Given directory does not exist!"
    exit 1
fi

# Loop through files in current (photo) directory
for picture in *
do
    # Check if the current picture is indeed a file
    if [[ -f "$picture" ]]
    then
        # Check for week or month timespan
        if [ "$TIMESPAN" = "week" ] 
        then
            timeperiod=$(date -r "$picture" +%W)
        else
            if [ "$TIMESPAN" = "maand" ] 
            then
                timeperiod=$(date -r "$picture" +%m)
            else
                # No valid timespan was given
                echo "Invalid timespan"
                exit 1
            fi
        fi

        # Check if photo folder with timeperiod exists
        # If not create the directory
        # Copy current file to the photo timeperiod directory
        if [[ -d "$PHOTO_FOLDER"/"$timeperiod" ]] 
        then
            cp -v "$picture" "$PHOTO_FOLDER"/"$timeperiod"/"$picture"
        else
            mkdir "$PHOTO_FOLDER"/"$timeperiod"
            cp -v "$picture" "$PHOTO_FOLDER"/"$timeperiod"/"$picture"
        fi
        
        # Create md5 hash and cut off file name
        old_file=$(sudo md5sum "$DIR"/"$picture" | cut -d " " -f1)
        new_file=$(sudo md5sum "$PHOTO_FOLDER"/"$timeperiod"/"$picture" | cut -d " " -f1)

        # Compare file hashes
        if [ "$old_file" = "$new_file" ] 
        then
            # Remove old file
            rm "$picture"
        else
            echo "$picture is invalid"
        fi
    fi

    echo ""
done