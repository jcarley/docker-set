#!/bin/bash

set -e

docker rmi jcarley/consul-template:latest || true
docker build -t jcarley/consul-template:latest .
