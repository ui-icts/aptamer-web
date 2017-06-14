# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  #config.vm.network :forwarded_port, guest: 9631, host: 9631
  config.vm.network :forwarded_port, guest: 4002, host: 4001
  #config.vm.network :forwarded_port, guest: 80, host: 3080
  config.vm.provision "main-install",type: :shell, :path => "vagrant-scripts/install.sh"
  config.vm.provision "apache-install",type: :shell, :path => "vagrant-scripts/apache-install.sh"
  config.vm.provision "hab-install", type: :shell, :path => "vagrant-scripts/hab-install.sh"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]
  config.vm.synced_folder "~/.hab", "/home/vagrant/.hab"
  config.vm.network "private_network", ip: "33.33.34.10", type: "dhcp", auto_config: false
end
