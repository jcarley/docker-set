#!/bin/bash

set -e

docker rm $(docker ps -qf status=exited) || true

docker rmi jcarley/consul-template:latest || true
docker build -t jcarley/consul-template:latest .
