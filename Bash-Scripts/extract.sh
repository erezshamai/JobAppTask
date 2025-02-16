#!/bin/bash

# Function to display help message
help_message() {
    echo "Usage: extract [-h] [-r] [-v] file [file...]"
    echo "\nOptions:"
    echo "  -h  Show this help message"
    echo "  -r  Recursively extract files in directories"
    echo "  -v  Verbose output"
    exit 0
}

# Initialize variables
verbose=false
recursive=false
not_extracted=0
decompressed=0


# Parse command-line options
while getopts ":hrv" opt; do
    case ${opt} in
        h) help_message ;;  # Display help message
        r) recursive=true ;;  # Enable recursive extraction
        v) verbose=true ;;  # Enable verbose output
        ?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;  # Handle invalid options
    esac
done

# Display arguments in verbose mode
if [ "$verbose" = true ]; then
    echo "====Strat Debug Command Arguments values:==="
    for arg in "$@"; do
        echo "Argument: '$arg'"
    done
    echo "====End Debug Command Arguments values:==="
fi

# Shift positional parameters
shift $((OPTIND -1))

# Function to extract a single file
extract_file() {
    local file="$1"
    local type=$(file -b --mime-type "$file")
    $verbose && echo "File type: $type"
    case "$type" in
        application/gzip) gunzip -f "$file" || { ((not_extracted++)); return 1; } ;;
        application/x-bzip2) bunzip2 -f "$file" || { ((not_extracted++)); return 1; } ;;
        application/zip) unzip -o "$file" -d "$(dirname "$file")" || { ((not_extracted++)); return 1; } ;;
        application/x-compress) uncompress -f "$file" || { ((not_extracted++)); return 1; } ;;
        *)
            ((not_extracted++))
            $verbose && echo "This file type ($type) identified as not compresssed. no action will be done on $file file"
            return 1 
            ;;        
    esac

    ((decompressed++))
    $verbose && echo "Extracted: $file"
    return 0
}


# Function to process files and directories
process() {
    local target="$1"
    $verbose && echo "Processing: $target"
    if [[ -d "$target" && "$recursive" == true ]]; then
        find "$target" -type f | while read -r file; do extract_file "$file"; done  # Recursively extract files
    elif [[ -f "$target" ]]; then
        extract_file "$target"  # Extract single file
    else
        ((not_extracted++))
        $verbose && echo "Skipping: $target (not a file or directory)"
    fi
}

# Loop through input arguments
for arg in "$@"; do
    process "$arg"
done

# Display summary if verbose is enabled
$verbose && echo "Total extracted: $decompressed"
$verbose && echo "Not extracted: $not_extracted"
exit $not_extracted
