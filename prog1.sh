#!/bin/bash

# Function to move files with confirmation for directories containing more than 3 C files
move_files() {
    local src="$1"
    local dest="$2"

    while IFS= read -r file; do
        local sub_dir=$(dirname "${file#$src/}")
        local dest_sub_dir="$dest/$sub_dir"
        mkdir -p "$dest_sub_dir"
        mv "$file" "$dest_sub_dir/"
    done < <(find "$src" -name "*.c")
}

# Function to confirm moving files if more than 3 C files in a directory
confirm_move() {
    local dir="$1"
    local count=$(find "$dir" -maxdepth 1 -name "*.c" | wc -l)

    if [ "$count" -gt 3 ]; then
        echo "More than 3 C files found in $dir"
        find "$dir" -maxdepth 1 -name "*.c"
        read -p "Confirm move? (y/n): " confirm

        if [[ $confirm != [yY] ]]; then
            return 1
        fi
    fi
    return 0
}

# Check for correct number of arguments
if [ $# -ne 2 ]; then
    echo "src and dest dirs missing"
    exit 1
fi

src_dir="$1"
dest_dir="$2"

if [ ! -d "$src_dir" ]; then
    echo "$src_dir not found"
    exit 0
fi

# Initialize an empty array
dirs=()

# Use a while loop to read the output of find into the array
while IFS= read -r dir; do
    dirs+=("$dir")
done < <(find "$src_dir" -type d)

# Iterate over the directories and process them
for dir in "${dirs[@]}"; do
    if confirm_move "$dir"; then
        move_files "$dir" "$dest_dir"
    fi
done
