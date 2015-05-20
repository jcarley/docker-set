#!/bin/bash

set -e

link_file() {
  if [[ ! -h "$2" ]]; then
    sudo ln -s $1 $2
  fi
}

enable_site() {
  link_file /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1
}

FILES=./*
shopt -s nullglob
for f in $FILES
do
  if test -f $f; then
    enable_site "$(basename $f)"
  fi
done


