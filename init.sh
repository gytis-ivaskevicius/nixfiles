#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $DIR
echo Updating $DIR/personal.nix. Please use this file for PC specific changes.

git update-index --assume-unchanged $DIR/personal.nix


