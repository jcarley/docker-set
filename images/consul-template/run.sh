#!/usr/bin/env bash

set -e

source /etc/environment

CONSUL_CONNECT=$COREOS_PRIVATE_IPV4:8500
CONSUL_CONFIG=/consul-template/config.d
CONSUL_MINWAIT=2s
CONSUL_MAXWAIT=10s
CONSUL_LOGLEVEL=debug

CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-templates/consul.cfg}

vars=$@

docker run -it --rm --name test_consul_template jcarley/consul-template \
  -log-level ${CONSUL_LOGLEVEL} \
  -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
  -config ${CONSUL_TEMPLATE} \
  -consul ${CONSUL_CONNECT} ${vars}


# default: &default
  # adapter: mysql2
  # encoding: utf8
  # reconnect: true
  # pool: 80
  # username: root
  # password: password
  # dead_connection_timeout: 10000000

# development:
  # <<: *default
  # reaping_frequency: 10
  # database: esp_submission_development

# # Warning: The database defined as "test" will be erased and
# # # re-generated from your development database when you run "rake".
# # # Do not set this db to the same as development or production.
# test: &test
  # <<: *default
  # database: esp_submission_test<%= ENV['TEST_ENV_NUMBER'] %>

# candidate:
  # <<: *test

# production:
  # <<: *test

# cucumber:
  # <<: *test

