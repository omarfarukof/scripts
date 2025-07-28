#! /bin/bash
# if 1st argument is missing ask for key
if [ -z "$1" ]; then
	read -p "Enter gpg key: " GPG_KEY
else
	GPG_KEY=$1
fi

pass init ${GPG_KEY}
pass git init

if [ -n "$2" ]; then
	pass git remote add origin "$2"
	pass git push -u origin HEAD
fi
