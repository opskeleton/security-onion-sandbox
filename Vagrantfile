# -*- mode: ruby -*-
# vi: set ft=ruby :
update = <<SCRIPT
if [ ! -f /tmp/up ]; then
  sudo aptitude update 
  touch /tmp/up
fi
SCRIPT


Vagrant.configure('2') do |config|

  bridge = ENV['VAGRANT_BRIDGE']
  bridge ||= 'eth0'
  mirror = ENV['VAGRANT_MIRROR']
  mirror ||= 'eth1'
  env  = ENV['PUPPET_ENV']
  env ||= 'dev'

  config.vm.box = 'security-onion-12.04.4_puppet-3.7.3' 
  config.vm.hostname = 'security-onion.local'
  config.vm.network :forwarded_port, guest: 80, host: 8085
  config.vm.network :forwarded_port, guest: 444, host: 8444
  config.ssh.insert_key = false

  config.vm.provision :shell, :inline => update

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ['modifyvm', :id, '--memory', 2048, '--cpus', 2]
    vb.customize ['modifyvm', :id, '--vram', '256']
    vb.customize ['setextradata', 'global', 'GUI/MaxGuestResolution', 'any']
    vb.customize ['setextradata', :id, 'CustomVideoMode1', '1024x768x32']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--rtcuseutc', 'on']
    vb.customize ['modifyvm', :id, '--accelerate3d', 'on']
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--nic3', 'bridged']
    vb.customize ['modifyvm', :id, '--bridgeadapter3', mirror]
    vb.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
    vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'manifests'
    puppet.manifest_file  = 'default.pp'
    puppet.options = '--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}'

  end

end
