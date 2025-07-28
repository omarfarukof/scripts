#! /bin/bash
mirrorlist-drop-caches() {
	sudo paccache -rk3
	yay -Sc --aur --noconfirm
}

mirrorlist-update-all() {
	local DISTRO="${1:-endeavouros}" # Default to endeavouros if no argument provided
	local TMPFILE
	TMPFILE="$(mktemp)"

	echo "Updating mirrors for distribution: $DISTRO"
	sudo true

	rate-mirrors --save="$TMPFILE" "$DISTRO" --max-delay=21600 &&
		sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup &&
		sudo mv "$TMPFILE" /etc/pacman.d/mirrorlist &&
		mirrorlist-drop-caches &&
		yay -Syyu --noconfirm

}

mirrorlist-update-all "${1:-endeavouros}"
