#!/bin/bash

set -e

docker rmi jcarley/ruby:2.2 || true
docker build --rm=true -t jcarley/ruby:2.2 .


