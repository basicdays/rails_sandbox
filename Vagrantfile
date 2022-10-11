# frozen_string_literal: true

SSH_PORT = 10_100

Vagrant.configure('2') do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'bento/ubuntu-22.04'
  config.vm.hostname = 'rails-sandbox'

  # disable default shared folder
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.ssh.forward_env = %w[TERM COLORFGBG]
  config.vm.network 'forwarded_port', id: 'ssh', host: SSH_PORT, guest: 22

  config.vm.provider 'virtualbox' do |vb|
    vb.name = 'rails-sandbox'
    vb.cpus = 2
    vb.memory = '4096'
    vb.default_nic_type = 'virtio'

    # Boxes weren't built with EFI enabled, need to fall back to legacy BIOS
    # vb.customize ['modifyvm', :id, '--firmware', 'efi']
    vb.customize ['modifyvm', :id, '--pae', 'off']
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    vb.customize ['modifyvm', :id, '--graphicscontroller', 'vmsvga']
    vb.customize ['modifyvm', :id, '--vrde', 'off']
    vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', '0', '--nonrotational', 'on']
  end

  ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
  config.vm.provision 'shell', privileged: false, inline: "echo #{ssh_pub_key} >> $HOME/.ssh/authorized_keys"
end
