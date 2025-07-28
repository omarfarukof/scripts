#! /bin/bash
# if 1st argument is missing ask for key name
if [ -z "$1" ]; then
	read -p "Enter key name: " KEY_NAME
else
	KEY_NAME=$1
fi

if [ -z "$2" ]; then
	OUT_DIR="."
else
	OUT_DIR=$2
fi

echo " Exporting GPG key ${KEY_NAME} to ${OUT_DIR}/public.pgp"
gpg --output ${OUT_DIR}/public.pgp --armor --export ${KEY_NAME}

echo " Exporting GPG secret key ${KEY_NAME} to ${OUT_DIR}/private.pgp"
gpg --output ${OUT_DIR}/private.pgp --armor --export-secret-key ${KEY_NAME}
