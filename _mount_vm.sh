#!/bin/bash

__infi__="""
# Name: Mount VM Disk
# Version: 1.0.0
# Description: Brief purpose description
# Usage: _mouny_vm [options] [arguments]
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

unmount_vmdk() {
	NBD_DEV="/dev/nbd${2:-1}"
	MOUNT_POINT="$HOME/mnt/"

	# Unmount if mounted
	if mountpoint -q "$MOUNT_POINT"; then
		sudo umount "$MOUNT_POINT" || {
			echo "Error: Failed to unmount $MOUNT_POINT" >&2
			exit 1
		}
	fi

	# Disconnect NBD device
	if [ -e "$NBD_DEV" ]; then
		sudo qemu-nbd -d "$NBD_DEV" || {
			echo "Error: Failed to disconnect $NBD_DEV" >&2
			exit 1
		}
	fi

	echo "Successfully unmounted and disconnected NBD device"
	exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	-h | --help) help ;;
	-v | --version) version ;;
	unmount) unmount_vmdk ;;
	-*)
		echo "Unknown option: $1" >&2
		exit 1
		;;
	*) break ;;
	esac
	shift
done

# Check for required tools
REQUIRED_CMDS=("modprobe" "qemu-nbd" "mount")
for cmd in "${REQUIRED_CMDS[@]}"; do
	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: $cmd is required but not installed" >&2
		exit 1
	fi
	echo "Found $cmd"
done
# Main script content here
# sudo modprobe nbd
# if ! sudo qemu-nbd -r -c /dev/nbd1 $1; then
#     echo "Error: qemu-nbd failed" >&2
#     exit 1
# fi
# # sudo qemu-nbd -r -c /dev/nbd1 $1

# if ! sudo mount /dev/nbd1p1 /mnt/vmdk; then
#     echo "Error: mount failed" >&2
#     echo "Disconnecting VMDK"
#     sudo qemu-nbd -d /dev/nbd1
#     exit 1
# fi
# sudo mount /dev/nbd1p1 /mnt/vmdk

# --- sanity checks ----------------------------------------------------------
# if [[ $# -ne 1 ]]; then
#     echo "Usage: $0 <image.vmdk>" >&2
#     exit 1
# fi

VMDK_PATH="$1"
NBD_DEV="/dev/nbd${2:-1}"
MOUNT_POINT="$HOME/mnt/"

# Load NBD module if not loaded
if ! lsmod | grep -q "^nbd"; then
	sudo modprobe nbd max_part=16 || {
		echo "Error: Failed to load NBD module" >&2
		exit 1
	}
fi

# Connect VMDK to NBD device
if ! sudo qemu-nbd -r -c "$NBD_DEV" "$VMDK_PATH"; then
	echo "Error: qemu-nbd failed to connect" >&2
	exit 1
fi

# Wait for partitions to be detected (sometimes needed)
sleep 2

# Check if partition exists
if [ ! -e "${NBD_DEV}" ]; then
	echo "Error: No partition found (${NBD_DEV}p1 does not exist)" >&2
	sudo qemu-nbd -d "$NBD_DEV"
	exit 1
fi

# Mount the partition
if ! sudo mount "${NBD_DEV}" "$MOUNT_POINT"; then
	echo "Error: Failed to mount ${NBD_DEV}p1 to $MOUNT_POINT" >&2
	sudo qemu-nbd -d "$NBD_DEV"
	exit 1
fi

echo "Successfully mounted $VMDK_PATH to $MOUNT_POINT"
