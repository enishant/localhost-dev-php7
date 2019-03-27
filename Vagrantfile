# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # config.vm.box = "v0rtex/xenial64"
  config.vm.box = "ubuntu/trusty64"

  # Do some network configuration
  config.vm.network "private_network", ip: "192.168.10.10"

  # Assign a quarter of host memory and all available CPU's to VM
  # Depending on host OS this has to be done differently.
  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    # Windows...
    else
      cpus = 4
      mem = 2048
    end
    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
  end

  # Setup Development Environment
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.provision "wpcli-install",
    type: "shell",
    path: "wpcli.sh",
    preserve_order: true

  config.vm.provision "wpcli-update",
    type: "shell",
    inline: "wp cli update",
    preserve_order: true

  # Virtual Hosts - Start

  config.vm.provision "example.com",
    type: "shell",
    path: "virtualhosts/example.com.sh",
    preserve_order: true

  # Virtual Hosts - End
end