#!/bin/bash

__infi__="""
# Name: Script Name
# Version: 1.0.0
# Description: Brief purpose description
# Usage: $(basename "$0") [options] [arguments]
# Options:
#   -h --help    Show this help
#   -v --version Show version
"""
set -euo pipefail

help() {
    echo "$__infi__"
    exit 0
}
version() {
    echo "Version: $(grep '^# Version:' "$0" | cut -d' ' -f3)"
    exit 0
}

check_required_tools() {
    local REQUIRED_CMDS=("sh")
    for cmd in "${REQUIRED_CMDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Error: $cmd is required but not installed" >&2
            exit 1
        fi
    done    
}

# Only execute if the script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    check_required_tools
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) help ;;
        -v|--version) version ;;
        -*) echo "Unknown option: $1" >&2; exit 1 ;;
        *) break ;;
    esac
    shift
done



# Only execute if the script is run directly (not sourced)
# Main script content here
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    # 
    echo "Hello from $(basename "$0")"
    # 
fi
