#! /bin/bash
# if 1st argument is missing ask for key
if [ -z "$1" ]; then
	read -p "Enter GIT URL: " GIT_URL
else
	GIT_URL=$1
fi

git clone ${GIT_URL} ${HOME}/.password-store
