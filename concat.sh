#!/bin/bash

# Color text output
GREEN=$(tput setaf 2)
LIME_YELLOW=$(tput setaf 190)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)

for dir in ${1%/}
do
    if test $(find "$dir" -maxdepth 1 -type f -iname "*.MP4" | wc -c) -eq 0
    then        
        printf "\nNo media files found in directory '"${dir##*/}"'\n"
    else

    printf "\nFound media in directory '"${dir##*/}"'"
    
    # Get all media files with mp4 extension and sort them by date to a text file
    find "$dir" -maxdepth 1 -iname "*.MP4" -type f -execdir ls -1tr "{}" + >> "$dir"/concat_list.txt
 
    # Remove path names from file path in text file so it is just the filename and extension
    sed -i 's/\(.*\)\/\(.*\)\.\(.*\)$/\2.\3/' "$dir"/concat_list.txt

    # Format text file to ffmpeg concatenation rules
    sed -i -r "s/(.*)/file '\1'/" "$dir"/concat_list.txt

    printf "\nCreated 'concat_list.txt' in directory '"${dir##*/}"'\n"

    # Add ouput directory
    if [ ! -d "$dir"/output ]; then
        printf "Added output directory to '"${dir##*/}"'\n"
        mkdir "$dir"/output
    else
        printf "'output' directory already exists\n"
    fi

    printf "Concatenating listed media to output/"${dir##*/}".MP4'\n\n"

    # Print found media sorted by date to console
    cat "$dir"/concat_list.txt ; echo

    # Start ffmpeg concatenation
    ffmpeg -f concat -safe 0 -i "$dir"/concat_list.txt -c copy "$dir"/output/"${dir##*/}".MP4

    #printf "Removed 'concat_list.txt' from directory '"${dir##*/}"'\n"
    #rm "$dir"/concat_list.txt

    printf "\n${GREEN}${BRIGHT}Operation Completed Successfully\n${NORMAL}"  

    printf "${LIME_YELLOW}*** Output file located in "$dir"/output/"${dir##*/}".MP4\n\n${NORMAL}"
    fi
done



