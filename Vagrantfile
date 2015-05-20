# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "user-data")
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Defaults for config options defined in CONFIG
$num_instances = 1
$instance_name_prefix = "core"
$update_channel = "stable"
$hostname = "devrigg01"
$enable_serial_logging = false
$share_home = false
$vm_gui = false
$vm_memory = ENV["VAGRANT_MEMORY"] || 2048
$vm_cpus = ENV["VAGRANT_CPUS"] || 2
$shared_folders = {}
$forwarded_ports = {}

if File.exist?(CONFIG)
  require CONFIG
end

$provision_script = <<-SCRIPT
  cd /home/core/docker-set
  fleetctl --endpoint=http://192.168.33.10:4001 --driver=etcd start \
    units/consul/consul-server units/consul/consul-server-announce \
    units/registrator/registrator units/redis/redis
SCRIPT

# docker pull progrium/registrator:latest
# docker build --rm=true -t="jcarley/consul-template" $DOCKER_SET/consul-template/
# docker build --rm=true -t="jcarley/nginx" $DOCKER_SET/nginx

# $startup_script = <<-SCRIPT
  # export DOCKER_SET=/home/vagrant/apps/docker-set

  # docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h consul01 --name consul01 progrium/consul -server -bootstrap -ui-dir /ui || docker start consul01
  # docker run -e NGINX_DEBUG=true jcarley/nginx
# SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # always use Vagrants insecure key
  # do not remove this line.
  config.ssh.insert_key = false

  config.vm.box = "coreos-%s" % $update_channel
  config.vm.hostname = $hostname

  config.vm.provider :vmware_fusion do |v|
    v.gui = $vm_gui
    v.vmx['memsize'] = $vm_memory
    v.vmx['numvcpus'] = $vm_cpus
  end

  config.vm.provider :virtualbox do |v|

    v.gui = $vm_gui
    v.memory = $vm_memory
    v.cpus = $vm_cpus

    v.customize ["modifyvm", :id,
                 "--nictype1", "Am79C973",
                 "--nictype2", "Am79C973"
                ]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  if $expose_docker_tcp
    config.vm.network "forwarded_port", guest: 2375, host: $expose_docker_tcp, auto_correct: true
  end

  $forwarded_ports.each do |guest, host|
    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
  end

  # setup cloud-config
  config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
  config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true

  #setup docker containers
  config.vm.provision "shell", inline: $provision_script, run: "once", :privileged => true

  #makes it easier to access box, no port mapping required
  #just add 192.168.33.10 esp-dev to hosts file
  config.vm.network :private_network, ip: "192.168.33.10"

  # Uncomment below to enable NFS for sharing the host machine into the coreos-vagrant VM.
  #config.vm.synced_folder ".", "/home/core/share", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp']
  $shared_folders.each_with_index do |(host_folder, guest_folder), index|
    config.vm.synced_folder host_folder.to_s, guest_folder.to_s, id: "core-share%02d" % index, nfs: true, mount_options: ['nolock,vers=3,udp']
  end

  if $share_home
    config.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", :nfs => true, :mount_options => ['nolock,vers=3,udp']
  end

end

