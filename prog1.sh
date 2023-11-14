#!/bin/bash

# Function to move files with confirmation for directories containing more than 3 C files
move_files() {
    local src="$1"
    local dest="$2"

    # Create destination directory if it doesn't exist (including subdirectories)
    mkdir -p "$dest"

    # Find all C files in the source directory
    local files=($(find "$src" -name "*.c"))

    # If more than 3 C files are found, ask for confirmation
    if [ "${#files[@]}" -gt 3 ]; then
        echo "Moving the following files from $src:"
        printf "%s\n" "${files[@]}"
        read -p "Confirm move? (y/n): " confirm

        if [[ $confirm != [yY] ]]; then
            return
        fi
    fi

    # Move files
    for file in "${files[@]}"; do
        mv "$file" "$dest/"
    done
}

# Check for correct number of arguments
if [ $# -ne 2 ]; then
    echo "src and dest dirs missing"
    exit 1
fi

src_dir="$1"
dest_dir="$2"

# Check if source directory exists
if [ ! -d "$src_dir" ]; then
    echo "$src_dir not found"
    exit 0
fi

# Move files from source to destination directory
move_files "$src_dir" "$dest_dir"
