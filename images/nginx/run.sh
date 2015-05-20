#!/bin/bash

pwd=$(pwd)

source /etc/environment
docker run -v $pwd/ssl:/etc/nginx/ssl -d --net=host  -e CONSUL_CONNECT=$COREOS_PRIVATE_IPV4:8500 --name nginx-proxy jcarley/nginx:1.9

