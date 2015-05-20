#!/bin/bash

set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

# Required vars
NGINX=${NGINX:-/usr/sbin/nginx}
NGINX_KV=${NGINX_KV:-nginx/template/default}

CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-/usr/local/bin/consul-template}
CONSUL_CONFIG=${CONSUL_CONFIG:-/consul-template/config.d}
CONSUL_CONNECT=${CONSUL_CONNECT:-127.0.0.1:8500}
CONSUL_MINWAIT=${CONSUL_MINWAIT:-2s}
CONSUL_MAXWAIT=${CONSUL_MAXWAIT:-10s}
CONSUL_LOGLEVEL=${CONSUL_LOGLEVEL:-debug}
CONSUL_SSL=""

# set up SSL
# if [ "$(ls -A /usr/local/share/ca-certificates)" ]; then
  # CONSUL_SSL="-ssl"
  # normally we'd use update-ca-certificates, but something about running it in
  # Alpine is off, and the certs don't get added. Fortunately, we only need to
  # add ca-certificates to the global store and it's all plain text.
  # cat /usr/local/share/ca-certificates/* >> /etc/ssl/certs/ca-certificates.crt
# else
  # CONSUL_SSL=""
# fi

function usage {
cat <<USAGE
  launch.sh             Start a consul-backed nginx instance

Configure using the following environment variables:

Nginx vars:
  NGINX                 Location of nginx bin
                        (default /usr/sibn/nginx)

  NGINX_KV              Consul K/V path to template contents
                        (default nginx/template/default)

  NGINX_DEBUG           If set, run consul-template once and check generated nginx.conf
                        (default not set)

Consul-template variables:
  CONSUL_TEMPLATE       Location of consul-template bin
                        (default /usr/local/bin/consul-template)


  CONSUL_CONNECT        The consul connection
                        (default consul.service.consul:8500)

  CONSUL_LOGLEVEL       Valid values are "debug", "info", "warn", and "err".
                        (default is "debug")
USAGE
}

function launch_consul_template {
  vars=$@

  if [ -n "${NGINX_DEBUG}" ]; then
    echo "Running consul template -once..."
    ${CONSUL_TEMPLATE} -log-level ${CONSUL_LOGLEVEL} \
                       -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                       -config /etc/consul-template/consul.cfg \
                       -consul ${CONSUL_CONNECT} ${CONSUL_SSL} -once ${vars}
    /nginx-run.sh
  else
    echo "Starting consul template..."
    exec ${CONSUL_TEMPLATE} -log-level ${CONSUL_LOGLEVEL} \
                       -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                       -config /etc/consul-template/consul.cfg \
                       -consul ${CONSUL_CONNECT} ${CONSUL_SSL} ${vars}
  fi
}

launch_consul_template $@


