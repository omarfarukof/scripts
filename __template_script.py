#!/usr/bin/env python3
"""
Sample Script Documentation

This script demonstrates a modern CLI tool with automatic argument parsing,
help generation, and version information. Replace this docstring with your
actual script documentation.

Examples:
# Show help
./script.py -h

# Show version
./script.py --version

# Basic usage
./script.py /some/directory --url http://example.com

# With short options
./script.py /some/directory -u http://example.com -v
"""

import argparse
import sys
import os
from typing import Optional, List, Dict
def env(ENV_VAR: str, default: Optional[str] = None) -> Optional[str]: 
    return os.environ.get(ENV_VAR, default)
    
__version__ = "1.0.0"  # Update with your actual version

# Configuration for automatic argument parsing
ARGUMENT_CONFIG = [
    {
        "flags": ["dir"],
        "options": {
            "metavar": "<directory>",
            "type": str,
            "help": "Target directory for processing"
        }
    },
    {
        "flags": ["--url", "-u"],
        "options": {
            "type": str,
            "default": None,
            "help": "Source URL to process (e.g. 'http://example.com')"
        }
    },
    {
        "flags": ["--verbose", "-v"],
        "options": {
            "action": "store_true",
            "help": "Enable verbose output"
        }
    }
]

def parse_arguments(config: List[Dict], description: str) -> argparse.Namespace:
    """Automatically generate parser from configuration"""
    parser = argparse.ArgumentParser(
        description=description,
        formatter_class=argparse.RawTextHelpFormatter
    )
    
    # Add version option
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}"
    )
    
    # Add configured arguments
    for item in config:
        flags = item["flags"]
        options = item["options"]
        parser.add_argument(*flags, **options)
    
    return parser.parse_args()

def main(args: argparse.Namespace) -> int:
    """
    Main processing function
    
    Args:
        args: Parsed command-line arguments
        
    Returns:
        int: Exit status (0 = success)
    """
    # ------------------------------
    # Add your actual logic here
    # ------------------------------
    
    if args.dir:
        print(f"Processing directory: {args.dir}")
        
    if args.url:
        print(f"Fetching URL: {args.url}")
        
    if args.verbose:
        print("Verbose mode enabled")
    
    # Example validation
    if not args.dir and not args.url:
        print("Error: Either directory or URL must be provided", file=sys.stderr)
        return 1
    
    return 0

if __name__ == "__main__":
    # Extract description from module docstring
    description = sys.modules[__name__].__doc__.strip() if __doc__ else ""
    
    # Parse arguments using configuration
    args = parse_arguments(ARGUMENT_CONFIG, description)
    
    # Execute main function
    sys.exit(main(args))