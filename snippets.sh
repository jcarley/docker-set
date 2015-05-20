#!/bin/bash

set -e

this_ip="$1"; shift
this_machine="$1"; shift
consul_args="$@"

echo $this_ip
echo $this_machine
echo $consul_args

etcdctl mkdir /consul.io/bootstrap/machines
etcdctl ls /consul.io/bootstrap/machines
etcdctl set /consul.io/bootstrap/machines/${this_machine} ${this_ip}

curl -sL https://discovery.etcd.io/e2e55e0aa71a92a19485fa105125bd97 | \
  jq -r '.node.nodes[0].value[0:-5] + ":4001"'


fleetctl --endpoint=http://192.168.33.10:4001 --driver=etcd start consul/consul-server consul/consul-server-announce
fleetctl list-units
etcdctl ls /consul/bootstrap/machines
etcdctl get /consul/bootstrap/machines/$(cat /etc/machine-id)

curl -v http://localhost:8500/v1/kv/?recurse
curl -X PUT -d 'test' -v http://localhost:8500/v1/kv/web/key1
curl -X PUT -d 'hiphop' -v http://localhost:8500/v1/kv/web/key1
curl -s -w "\n" http://localhost:8500/v1/kv/web/key1


/usr/bin/docker run --name registrator -h $HOSTNAME -v /var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest -internal -resync 60 consul://192.168.33.10:8500


# Upgrading Docker
wget -qO- https://get.docker.com/gpg | apt-key add -
echo deb http://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

ADD ./versions.txt /root/versions.txt
RUN xargs -L 1 rbenv install < /root/versions.txt
