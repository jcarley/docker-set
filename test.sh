#!/usr/bin/env bash

set -e

while read -r folder repo version; do
  [[ $folder = \#* ]] && continue
  # echo "docker build -t ${repo}:${version} ${folder}"
  docker build -t ${repo}:${version} ${folder}
done < ./build_manifest.txt

