#!/bin/bash

# Define the environment setting as a single variable
ENV_SETTING="SKIKO_RENDER_API=SOFTWARE_FAST"

# Function to ensure the .desktop file has the correct Exec line
ensure_desktop_env_var() {
	local DESKTOP_FILE="$1"

	# Check if the .desktop file exists
	if [ ! -f "$DESKTOP_FILE" ]; then
		echo -e "\033[0;31mError: $DESKTOP_FILE not found.\033[0m"
		return 1
	fi

	# --- Step 1: Ensure 'env' prefix is present ---
	# Check if the Exec line already starts with 'Exec=env '
	# If 'Exec=' exists but not 'Exec=env ', add 'env '
	sed -i '/^Exec=/ { /env /! s/^Exec=/Exec=env / }' "$DESKTOP_FILE"

	# --- Step 2: Ensure the specific environment variable is present after 'env' ---
	# If the line starts with 'Exec=env ' and does NOT contain the ENV_SETTING,
	# insert ENV_SETTING after 'Exec=env '.
	sed -i "/^Exec=env / { /${ENV_SETTING}/! s|^Exec=env |Exec=env ${ENV_SETTING} |}" "$DESKTOP_FILE"

	# --- Final Check: Verify the desired format ---
	# Check if the line starts with 'Exec=env ' AND contains the ENV_SETTING
	if grep -q "^Exec=env " "$DESKTOP_FILE" && grep -q "$ENV_SETTING" "$DESKTOP_FILE"; then
		echo -e "\033[0;32mSuccessfully ensured Exec line has 'env ${ENV_SETTING}' prefix and the correct command in $DESKTOP_FILE.\033[0m"
		return 0
	else
		echo -e "\033[0;31mError: The Exec line in $DESKTOP_FILE is not in the expected format.\033[0m"
		return 1
	fi
}

# New function to process desktop files in a directory
process_desktop_files_in_dir() {
	local search_dir="$1"
	# Pattern for case-insensitive matching of filenames containing "abdownloadmanager" and ending with ".desktop"
	local filename_pattern="*abdownloadmanager*.desktop"

	echo -e "\033[0;33mSearching for desktop files matching '$filename_pattern' in '$search_dir'...\033[0m"

	# Find files matching the pattern (case-insensitive) in the specified directory (non-recursive)
	# -maxdepth 1: only search in the specified directory, not subdirectories.
	# -type f: only consider files.
	# -iname: case-insensitive name matching.
	# -print0 and xargs -0: safely handle filenames with spaces or special characters.
	find "$search_dir" -maxdepth 1 -type f -iname "$filename_pattern" -print0 | while IFS= read -r -d $'\0' desktop_file; do
		echo -e "\033[0;33mProcessing file: $desktop_file\033[0m"
		if ensure_desktop_env_var "$desktop_file"; then
			echo -e "\033[0;32mSuccessfully processed $desktop_file.\033[0m"
		else
			echo -e "\033[0;31mFailed to process $desktop_file.\033[0m"
		fi
	done
}

# --- Main execution ---
# Define the directory to search for desktop files using the native HOME variable
SEARCH_DIRECTORY="$HOME/.local/share/applications/"
echo -e "\033[0;33mSearching for desktop files in applications '$SEARCH_DIRECTORY'...\033[0m"
process_desktop_files_in_dir "$SEARCH_DIRECTORY"

AUTOSTART_DIR="$HOME/.config/autostart/"
echo -e "\033[0;33mSearching for desktop files in autostart '$AUTOSTART_DIR'...\033[0m"
process_desktop_files_in_dir "$AUTOSTART_DIR"

# Exit with the status of the last operation
exit $?
