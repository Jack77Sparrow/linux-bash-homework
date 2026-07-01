#!/bin/bash


display_help () {
    echo "Usage: ./script.sh [options] [directory]"
    echo "Options:"
    echo "  -h        Display help"
    echo "  -r        Search recursively"
    echo "  -d ARG    Depth of recursion (use with -r, e.g., -d 2)"
    exit 0
}

if [ "$1" == '-h' ]
then
    display_help 
fi

USE_RECURSION=false
DEPTH=""
dir='.'



if [ "$1" == '-r' ]
then
    USE_RECURSION=true

    if [ "$2" == '-d' ]
    then 
        DEPTH=$2
        dir=${4:-.}
    else
        dir=${2:-.}
    fi
else
    dir=${1:-.}
fi

if [ "$USE_RECURSION" == true ]
then
    if [ -n "$DEPTH" ]
    then 
        files=$(find "$dir" -maxdepth "$DEPTH")
    else
        files=$(find "$dir")
    fi
else
    files=$(find "$dir" -maxdepth 1)
fi

# Function that analyzes files
print_file_types () {

    for file in $files; do
        
        basename_file=$(basename "$file")
        # checks if the file is soft link
        if [ -h "$file" ]; then
            echo "File $basename_file is soft link"
        # checks if the file is directory
        elif [ -d "$file" ]; then
            echo "File $basename_file is directory"
        # checks if the file is executable
        elif [ -x "$file" ]; then
            echo "File $basename_file is executable"
        # prints just regular file
        else
            echo "File $basename_file is a regular file"
        fi
    done
}

# run function
print_file_types "$files"
