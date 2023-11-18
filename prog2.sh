#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "data file or output file not found"
    exit 1
fi

data_file="$1"
output_file="$2"

# Check if data file exists
if [ ! -f "$data_file" ]; then
    echo "$data_file not found"
    exit 1
fi

# Function to process each line and update column sums
update_sums() {
    local line="$1"
    local -n sums_ref=$2
    local -a numbers=($(echo $line | tr ',:;' ' '))

    for i in "${!numbers[@]}"; do
        sums_ref[$i]=$((${sums_ref[$i]:-0} + ${numbers[$i]}))
    done
}

# Array to store the sum of each column
declare -a column_sums

# Read each line of the file and update the column sums
while IFS= read -r line; do
    update_sums "$line" column_sums
done < "$data_file"

# Write the results to the output file, creating or overwriting as necessary
> "$output_file" # Clears the file if it exists, or creates a new one
for i in "${!column_sums[@]}"; do
    echo "Col $((i + 1)) : ${column_sums[$i]}" >> "$output_file"
done

echo "Output written to $output_file"
