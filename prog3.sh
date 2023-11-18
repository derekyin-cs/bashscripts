#!/bin/bash

# Check if a data file is provided
if [ -z "$1" ]; then
    echo "missing data file"
    exit 1
fi

data_file="$1"
shift  # Shift all arguments to the left, data_file is now $1, weights start from $2

# Check if data file exists
if [ ! -f "$data_file" ]; then
    echo "$data_file not found"
    exit 1
fi

# Initialize arrays for weights
declare -a weights=("$@")

# Initialize total variables
total_weighted_score=0
total_weight=0
student_count=0

# Read the data file line by line, skipping the header
while IFS=, read -r id q1 q2 q3 q4 q5; do
    # Ignore the header line
    if [ "$id" == "ID" ]; then
        continue
    fi

    # Populate scores array
    scores=($q1 $q2 $q3 $q4 $q5)

    # Initialize student's scores and weights
    student_weighted_score=0
    student_total_weight=0

    # Loop through all provided scores
    for i in "${!scores[@]}"; do
        # Assign weight 1 if not specified, or take the provided weight
        weight=${weights[$i]:-1}

        # Calculate the weighted score for the student and add it to the total
        student_weighted_score=$((student_weighted_score + scores[i] * weight))
        student_total_weight=$((student_total_weight + weight))
    done

    # Add the student's weighted score to the overall total
    total_weighted_score=$((total_weighted_score + student_weighted_score))
    total_weight=$((total_weight + student_total_weight))
    student_count=$((student_count + 1))

# Use process substitution to avoid subshell created by pipeline
done < <(tail -n +2 "$data_file")

# Calculate and print the overall weighted average across all students
if [ $total_weight -ne 0 ] && [ $student_count -ne 0 ]; then
    overall_weighted_average=$((total_weighted_score / total_weight))
    echo "The weighted average for all students is: $overall_weighted_average"
else
    echo "Error: No student data found or total weight is zero."
    exit 1
fi
