#!/bin/bash

set -e

docker rmi jcarley/nginx:1.9 || true
docker build --rm=true -t jcarley/nginx:1.9 .

