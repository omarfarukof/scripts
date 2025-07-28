# My Scripts






# Script Template


```bash
#!/bin/bash
# Name: Script Name
# Version: 1.0.0
# Description: Brief purpose description
# Usage: script_name [options]
# Options:
#   -h --help    Show this help
#   -v --version Show version

help() {
    grep '^#/' "$0" | cut -c4-
    exit 0
}
version() {
    grep '^# Version:' "$0" | cut -d' ' -f3
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) help ;;
        -v|--version) version ;;
        *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
    shift
done

#############################################################
# Main script logic here
echo "Hello World"

```