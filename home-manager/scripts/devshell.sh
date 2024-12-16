#!/usr/bin/env bash

# Check if the name argument is provided
if [ -z "$1" ]; then
  echo "Devshell initialization usage: $0 <name>"
  exit 1
fi

if [ -f flake.nix ]; then
  echo "Flake already initialized. Quitting."
  exit 0
fi

NAME=$1
echo "Initializing devshell for $NAME."
nix flake init --quiet --template $NIX_CONF#$NAME

if [ $? -ne 0 ]; then
  echo "Flake initialization failed!"
  exit 1
fi

GITIGNORE_CONTENT=".direnv"
if ! ([ -f .gitignore ] && rg -Fxq "$GITIGNORE_CONTENT" .gitignore); then
  echo "  Adding $GITIGNORE_CONTENT to .gitignore"
  echo -e "\n$GITIGNORE_CONTENT" >>.gitignore
fi

echo "$NAME environment set up!"
