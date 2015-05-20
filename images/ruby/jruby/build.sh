#!/bin/bash

set -e

docker rmi jcarley/jruby:1.7 || true
docker build --rm=true -t jcarley/jruby:1.7 .
