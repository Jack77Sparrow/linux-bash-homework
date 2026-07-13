#!/bin/bash

# display help message
display_help () {
    echo "Usage: ./script.sh [options] [directory]"
    echo "Options:"
    echo "  -h        Display help"
    echo "  -r        Search recursively"
    echo "  -d ARG    Depth of recursion (use with -r, e.g., -d 2)"
    exit 0
}

# default values for flags
USE_RECURSION=false
DEPTH=""

# parse command line options using getopts
while getopts "hrd:" opt; do
    case $opt in
        h) display_help ;;
        r) USE_RECURSION=true ;;
        d) DEPTH=$OPTARG ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done

# remove parsed options from arguments
shift $((OPTIND - 1))

# check if more than one directory parameter is given
if [ $# -gt 1 ]; then
    echo "Error: More than one directory parameter is given." >&2
    exit 1
fi

# use provided directory or default to current directory
dir=${1:-.}

# find files based on recursion and depth options
if [ "$USE_RECURSION" == true ]; then
    if [ -n "$DEPTH" ]; then 
        files=$(find "$dir" -maxdepth "$DEPTH")
    else
        files=$(find "$dir")
    fi
else
    files=$(find "$dir" -maxdepth 1)
fi

# main function to analyze and print file types
print_file_types () {
    # loop 1: find and print only executable files
    for file in $files; do
        if [ -f "$file" ] && [ -x "$file" ] && [ ! -h "$file" ]; then
            echo "File $file is executable"
        fi
    done

    # loop 2: find and print only soft links
    for file in $files; do
        if [ -h "$file" ]; then
            echo "File $file is soft link"
        fi
    done
}

# run the analyze function
print_file_types
