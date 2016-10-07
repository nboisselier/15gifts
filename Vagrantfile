# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose"
  end

  config.vm.box = "ubuntu/trusty32"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "256"
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

# NB 07.10.16   config.vm.provider :virtualbox do |vb|
# NB 07.10.16     vb.customize ['modifyvm', :id, '--usb', 'on']
# NB 07.10.16     vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'MemoryCardReader', '--vendorid', '0x05ac', '--productid', '0x8403']
# NB 07.10.16   end
end
