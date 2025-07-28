#!/bin/bash

SCRIPT_DIR="${HOME}/scripts"
SCRIPT_BIN_DIR="${HOME}/.local/bin/scripts"

# Create directories if they don't exist
mkdir -p "$SCRIPT_BIN_DIR"

# Function to make a file executable
make_executable() {
	local file="$1"
	if [[ -f "$file" ]]; then
		chmod +x "$file"
		echo "Made executable: $file"
		return 0
	else
		echo "Error: File not found - $file" >&2
		return 1
	fi
}

# Function to create a soft link
make_link() {
	local source_file="$1"
	local target_link="${SCRIPT_BIN_DIR}/$(basename "$source_file")"

	if [[ -f "$source_file" ]]; then
		ln -sf "$source_file" "$target_link"
		echo "Created link: $target_link → $source_file"
		return 0
	else
		echo "Error: Source file not found - $source_file" >&2
		return 1
	fi
}

make_copy() {
	local source_file="$1"
	local target_link="${SCRIPT_BIN_DIR}/$(basename "$source_file")"

	if [[ -f "$source_file" ]]; then
		cp -i "$source_file" "$target_link"
		echo "Created a copy: $target_link → $source_file"
		return 0
	else
		echo "Error: Source file not found - $source_file" >&2
		return 1
	fi
}

# Function to make executable and create link
make_link_bin() {
	local file="$1"
	if make_executable "$file"; then
		make_link "$file"
	fi
}

# Function to make executable bin
make_bin() {
	local source_file="$1"
	local source_file_bin="${SCRIPT_BIN_DIR}/$(basename "$source_file")"

	if make_copy "$source_file"; then
		make_executable "$source_file_bin"
	fi

	# Check if the setup function exists using grep
	if grep -q "^setup[[:space:]]*\(\)" "$source_file_bin"; then
		echo "Setup function found in $source_file_bin"
		# Execute the setup function using source and calling the function
		source "$source_file_bin"
		echo "Executing setup function in $source_file_bin"
		setup
	else
		echo "Setup function not found in $source_file_bin"
	fi

}

# Install scripts from list file
install_from_list() {
	local list_file="${SCRIPT_DIR}/__list_script_bin.sh"

	if [[ ! -f "$list_file" ]]; then
		echo "Error: List file not found - $list_file" >&2
		return 1
	fi

	# Read list file, handling comments and empty lines
	while IFS= read -r script_name || [[ -n "$script_name" ]]; do
		# Remove comments and trim whitespace
		script_name="${script_name%%#*}"
		script_name="$(echo -e "${script_name}" | tr -d '[:space:]')"

		# Skip empty lines
		[[ -z "$script_name" ]] && continue

		local script_path="${SCRIPT_DIR}/${script_name}"

		if [[ -f "$script_path" ]]; then
			make_bin "$script_path"
		else
			echo "Warning: Script not found - $script_path" >&2
		fi
	done < <(grep -v '^[[:space:]]*#' "$list_file" | grep -v '^$')
}

# Optional: Process all scripts in directory
install_all_scripts() {
	for script in "$SCRIPT_DIR"/*; do
		if [[ -f "$script" ]]; then
			make_bin "$script"
		fi
	done
}

# Main execution
if [[ $# -eq 0 ]]; then
	echo "Processing all scripts in $SCRIPT_DIR"
	install_from_list
else
	for file in "$@"; do
		make_bin "$file"
	done
fi

echo "Setup completed. Add to PATH if needed:"
echo "export PATH=\"\$PATH:$SCRIPT_BIN_DIR\""
