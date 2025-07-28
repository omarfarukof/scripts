#!/bin/zsh

# Define the target file
ZSHRC_FILE="$HOME/.zshrc"
TEMP_FILE="${ZSHRC_FILE}.tmp"

# The new export block we want to use
NEW_EXPORT="# Gemini API Key
export GEMINI_API_KEY=\$(pass show gemini/api-key | head -n1)"

# Check if the export already exists
if grep -q "export GEMINI_API_KEY=" "$ZSHRC_FILE"; then
	echo "Found existing GEMINI_API_KEY export. Replacing it..."

	# Remove any existing Gemini API Key comment and export
	awk -v new_export="$NEW_EXPORT" '
        /# Gemini API Key/ { in_block = 1; next }
        in_block && /export GEMINI_API_KEY=/ { in_block = 0; next }
        /export GEMINI_API_KEY=/ { print new_export; replaced = 1; next }
        { 
            if (in_block) in_block = 0; 
            print 
        }
        END {
            if (!replaced) print new_export
        }
    ' "$ZSHRC_FILE" >"$TEMP_FILE" && mv "$TEMP_FILE" "$ZSHRC_FILE"

	echo "Successfully updated GEMINI_API_KEY export"
else
	echo "No existing GEMINI_API_KEY found. Adding it to .zshrc..."
	echo "$NEW_EXPORT" >>"$ZSHRC_FILE"
	echo "Successfully added GEMINI_API_KEY export"
fi

# Source the updated file to apply changes
source "$ZSHRC_FILE" 2>/dev/null

# Verify the key was set properly
if [ -n "$GEMINI_API_KEY" ]; then
	echo "GEMINI_API_KEY is now set (first 4 chars: ${GEMINI_API_KEY:0:4}...)"
else
	echo "WARNING: GEMINI_API_KEY was not set correctly" >&2
fi
