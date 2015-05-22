#!/usr/bin/env bash

set -e

source /etc/environment

CONSUL_CONNECT=$COREOS_PRIVATE_IPV4:8500
CONSUL_CONFIG=/consul-template/config.d
CONSUL_MINWAIT=2s
CONSUL_MAXWAIT=10s
CONSUL_LOGLEVEL=debug

CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-/consul-template/consul.cfg}

vars=$@

docker run -it --rm --name test_consul_template -v $PWD/templates:/consul-template jcarley/consul-template \
  -log-level ${CONSUL_LOGLEVEL} \
  -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
  -config ${CONSUL_TEMPLATE} \
  -consul ${CONSUL_CONNECT} ${vars}

echo
echo

