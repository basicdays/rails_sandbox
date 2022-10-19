# frozen_string_literal: true

project_name = File.basename __dir__
virtual_machines = [
  {
    name: 'app-1',
    service: 'app',
    ssh_port: 10_100,
    primary: true
  }
].freeze
ansible_groups = virtual_machines.each_with_object({}) do |vm, groups|
  project_key = project_name.gsub '-', '_'
  groups[project_key] ||= []
  groups[project_key] << vm[:name]
  groups[vm[:service]] ||= []
  groups[vm[:service]] << vm[:name]
end

Vagrant.configure('2') do |config|
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = 'bento/ubuntu-22.04'
  config.vm.box_version = '202206.13.0'

  # disable default shared folder
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provider 'virtualbox' do |vb|
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

    vb.customize ['guestproperty', 'set', :id, '/Project/Name', project_name]
    vb.customize ['guestproperty', 'set', :id, '/Ansible/Host', 'localhost']
    vb.customize ['guestproperty', 'set', :id, '/Ansible/User', 'vagrant']
  end

  virtual_machines.each do |name:, service:, ssh_port:, primary: false|
    config.vm.define name, primary: primary do |inst|
      inst.vm.hostname = name
      inst.vm.network 'forwarded_port', id: 'ssh', host: ssh_port, guest: 22
      inst.vm.provider 'virtualbox' do |vb|
        vb.name = "#{project_name}-#{name}"
        vb.customize ['guestproperty', 'set', :id, '/Project/Service', service]
        vb.customize ['guestproperty', 'set', :id, '/Ansible/Port', ssh_port.to_s]
      end
    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provisioning/playbooks/site.yml'
    # ansible.config_file = 'provisioning/ansible.cfg'
    ansible.groups = ansible_groups
  end
end
