#!/bin/bash

# Function to calculate checksum of a URL
calculate_checksum() {
    local url="$1"
    curl -s "$url" | shasum -a 256 | cut -d ' ' -f 1
}

# Function to set text color using tput
set_text_color() {
    local color_code="$1"
    tput setaf "$color_code"
}

# Function to reset text color using tput
reset_text_color() {
    tput sgr0
}

# Function to determine color based on change rate
get_color() {
    local change_rate="$1"
    if ((change_rate >= 95)); then
        echo 1  # Deep Red for changes over 95%
    elif ((change_rate >= 90)); then
        echo 9  # Light Red for changes over 90%
    elif ((change_rate >= 85)); then
        echo 160  # Pink for changes over 85%
    elif ((change_rate >= 80)); then
        echo 3  # Orange for changes over 80%
    elif ((change_rate >= 75)); then
        echo 208  # Light Orange for changes over 75%
    elif ((change_rate >= 70)); then
        echo 202  # Coral for changes over 70%
    elif ((change_rate >= 65)); then
        echo 3  # Orange for changes over 65%
    elif ((change_rate >= 60)); then
        echo 208  # Light Orange for changes over 60%
    elif ((change_rate >= 55)); then
        echo 172  # Peach for changes over 55%
    elif ((change_rate >= 50)); then
        echo 5  # Yellow for changes over 50%
    elif ((change_rate >= 40)); then
        echo 3  # Orange for changes over 40%
    elif ((change_rate >= 30)); then
        echo 6  # Purple for changes over 30%
    elif ((change_rate >= 20)); then
        echo 92  # Light Green for changes over 20%
    elif ((change_rate >= 10)); then
        echo 84  # Lime for changes over 10%
    elif ((change_rate > 0)); then
        echo 4  # Blue for changes (but not over 10%)
    else
        echo 2  # Green for no changes
    fi
}


# Function to check if checksum has changed
has_changed() {
    local url="$1"
    local current_checksum=$(calculate_checksum "$url")
    local url_index=-1

    for ((i = 0; i < ${#url_array[*]}; i+=3)); do
        if [[ "${url_array[i]}" == "$url" ]]; then
            url_index=$i
            break
        fi
    done

    if [ "$url_index" -ne -1 ]; then
        local previous_checksum="${url_array[url_index + 1]}"
        local change_count="${url_array[url_index + 2]}"

        if [ -n "$previous_checksum" ] && [ "$previous_checksum" != "$current_checksum" ]; then
            url_array[url_index + 1]="$current_checksum"
            url_array[url_index + 2]=$((change_count + 1))
        fi

        local percentage_change=$((100 * change_count / (change_count + 1)))
    else
        url_array+=("$url" "$current_checksum" 0)
        local percentage_change=0
    fi

    local change_rate="${url_array[url_index + 2]}"
    local color=$(get_color "$change_rate")

    set_text_color "$color"
    echo "Checksum for $url -> ${current_checksum:0:4} -x-> ${previous_checksum:0:4} -change-> [$percentage_change %])"
    reset_text_color
}

# Check if at least one URL is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <URL1> [URL2] [URL3] ..."
    exit 1
fi

# Initialize variables
url_array=()

# Main loop
while true; do
    for url in "${@}"; do
        has_changed "$url"
    done
    sleep 0.1
done
