#!/bin/bash

function create_development_shell() {
  if [ -z "$1" ]; then
    echo "No template specified."
    return
  fi

  local AVAILABLE_TEMPLATES=$(get_directory_names $NIX_CONF/templates $1)
  if [[ -z ""$AVAILABLE_TEMPLATES ]]; then
    echo "$1 template doesn't exist yet."
  else
    . "$HOME/.local/bin/scripts/devshell.sh" $1
  fi
}

function get_directory_names() {
  if [ -z "$1" ] || [ ! -d "$1" ]; then
    return
  fi

  find "$1" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep "$2"
}
