#!/usr/bin/env bash

set -e

source /etc/environment
source /etc/application

CONSUL_CONNECT=$COREOS_PRIVATE_IPV4:8500
CONSUL_CONFIG=${CONSUL_CONFIG:-/consul-template/config.d/consul.cfg}
CONSUL_MINWAIT=2s
CONSUL_MAXWAIT=10s
CONSUL_LOGLEVEL=debug

vars=$@

docker run -it --rm --name test_consul_template -e APPLICATION_ENV=${APPLICATION_ENV} \
  -v $PWD/templates:/consul-template/templates \
  -v $PWD/config.d:/consul-template/config.d \
  -v $PWD/artifacts:/consul-template/artifacts \
  jcarley/consul-template \
  -log-level ${CONSUL_LOGLEVEL} \
  -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
  -config ${CONSUL_CONFIG} \
  -consul ${CONSUL_CONNECT} ${vars}

echo
echo

