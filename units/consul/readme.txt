https://registry.hub.docker.com/u/progrium/consul/

Getting the docker0 bridge ip address programatically
  ifconfig docker0 | awk '/\<inet\>/ { print $2}'

Getting the coreos private ipv4 address
  source /etc/environment
  reference ${COREOS_PRIVATE_IPV4}

Start etcd and fleet (and maybe other services) using the user-data file

