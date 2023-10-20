#!/bin/bash

DATA_FILE="webpage_records.dat"

# Function to calculate the SHA1 checksum of a URL
calculate_checksum() {
    local url="$1"
    curl -s "$url" | shasum -a 1 | awk '{print $1}'
}

# Function to format the text in red or green (for Linux)
format_text_linux() {
    local color="$1"
    local text="$2"
    echo -e "\e[${color}m${text}\e[0m"
}

# Function to format the text in red or green (for macOS)
format_text_macos() {
    local color="$1"
    local text="$2"
    tput setaf "$color"
    echo "$text"
    tput sgr0
}

# Function to record the result
record_result() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local status="$1"
    local url="$2"
    local checksum="$3"
    local tempfile=$(mktemp)

    # Update the last recorded checksum for the same URL
    awk -v url="$url" -v checksum="$checksum" -F',' 'BEGIN {OFS = FS} $3 == url { $4 = checksum; updated = 1 } { print } END { if (!updated) { print timestamp, status, url, checksum } }' "$DATA_FILE" > "$tempfile"

    # Replace the original file with the updated data
    mv "$tempfile" "$DATA_FILE"
}

# Function to display records
display_records() {
    if [ -e "$DATA_FILE" ]; then
        while IFS=, read -r timestamp status url checksum; do
            status_text=$(format_text_macos 1 "true")  # Red text for "true" on macOS
            if [ "$status" == "false" ]; then
                status_text=$(format_text_macos 2 "false")  # Green text for "false" on macOS
            fi
            echo "[$timestamp] Status: $status_text URL: $url Checksum: $checksum"
        done < "$DATA_FILE"
    else
        echo "No records found."
    fi
}

# Function to display a list of websites with recorded checksums
display_website_list() {
    if [ -e "$DATA_FILE" ]; then
        awk -F',' '{print $3}' "$DATA_FILE" | sort -u | sed 's/^/URL: /'
    else
        echo "No records found."
    fi
}

# Check the running OS type
if [ "$OSTYPE" == "linux-gnu" ] || [ "$(uname)" == "Linux" ]; then
    FORMAT_TEXT_FUNCTION=format_text_linux
elif [ "$OSTYPE" == "darwin" ] || [ "$(uname)" == "Darwin" ]; then
    FORMAT_TEXT_FUNCTION=format_text_macos
else
    FORMAT_TEXT_FUNCTION=echo
fi

# Check the command line arguments
if [ "$#" -eq 1 ] && [ "$1" == "-l" ]; then
    # Display website records
    display_records
elif [ "$#" -eq 1 ] && [ "$1" == "-lm" ]; then
    # Display a list of websites with recorded checksums
    display_website_list
elif [ "$#" -eq 2 ] && [ "$1" == "-m" ]; then
    # Monitor a webpage using the last recorded checksum and update it
    URL="$2"
    LAST_CHECKSUM=$(awk -v url="$URL" -F',' '$3 == url {cs = $4} END {print cs}' "$DATA_FILE")
    if [ -z "$LAST_CHECKSUM" ]; then
        echo "No previous record found for $URL."
        exit 1
    fi
    CURRENT_CHECKSUM=$(calculate_checksum "$URL")
    if [ "$LAST_CHECKSUM" == "$CURRENT_CHECKSUM" ]; then
        echo "Website status: $($FORMAT_TEXT_FUNCTION 32 "No change")"
        RECORD_ACTION="2"  # Disregard new checksum
    else
        echo "Website status: $($FORMAT_TEXT_FUNCTION 31 "Change detected")"
        RECORD_ACTION="1"  # Update website checksum
        record_result "$RECORD_ACTION" "$URL" "$CURRENT_CHECKSUM"
    fi
    # Update the last recorded checksum
    record_result "$RECORD_ACTION" "$URL" "$CURRENT_CHECKSUM"
elif [ "$#" -eq 3 ] && [ "$1" == "-c" ]; then
    # Compare a given checksum with a URL
    CS="$2"
    URL="$3"
    CURRENT_CHECKSUM=$(calculate_checksum "$URL")
    if [ "$CS" == "$CURRENT_CHECKSUM" ]; then
        echo "Checksums match. Website status: $($FORMAT_TEXT_FUNCTION 32 "No change")"
        RECORD_ACTION="2"  # Disregard new checksum
    else
        echo "Checksums do not match. Website status: $($FORMAT_TEXT_FUNCTION 31 "Change detected")"
        RECORD_ACTION="1"  # Update website checksum
        # Update the last recorded checksum
        record_result "$RECORD_ACTION" "$URL" "$CURRENT_CHECKSUM"
    fi
    
else
    echo "Usage:
    - To monitor a webpage (using last recorded checksum): $0 -m <URL>
    - To compare a checksum and a URL: $0 -c <checksum> <URL>
    - To load and display records: $0 -l
    - To display a list of websites with recorded checksums: $0 -lm"
    exit 1
fi
