#!/bin/sh

if [[ $EUID -eq 0 ]]; then
   echo "Please run this script as normal user"
   exit 1
fi

cd $(dirname "${BASH_SOURCE[0]}")

echo Updating .git folder owner to $USER
sudo chown -R $USER:wheel .git

echo Disabling GIT tracking for personal.nix
git update-index --assume-unchanged personal.nix


