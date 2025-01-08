#!/bin/bash

function git_add_commit_push() {
  git add .
  git commit -m "$1"
  git push
}

function git_clone_own_repo() {
  local BASE_URL="git@github.com:illusaen/"
  local DEFAULT_RESULT="git clone ${BASE_URL}$1.git"
  case "$0" in
  ggcl)
    echo "$DEFAULT_RESULT"
    ;;
  grl)
    local REPO=$(gh repo list | fzf | grep -oP '/\K[^\s]+')
    if [[ -z $REPO ]]; then
      echo "No repository selected!"
    else
      git clone "git@github.com:${REPO}.git"
    fi
    ;;
  esac
}

function mkd() {
  mkdir -p "$1"
  cd "$1"
}
