#! /bin/bash
# if 1st argument is missing ask for key name
if [ -z "$1" ]; then
	read -p "Enter key name: " KEY_NAME
else
	KEY_NAME=$1
fi

echo " Deleting GPG Secret key from ${KEY_NAME}"
gpg --delete-secret-keys ${KEY_NAME}

echo " Deleting GPG Public key from ${KEY_NAME}"
gpg --delete-keys ${KEY_NAME}
