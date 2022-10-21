# frozen_string_literal: true

def to_group(name)
  name.gsub '-', '_'
end

def get_ansible_groups(project_name, vms)
  ansible_groups = vms.each_with_object({}) do |vm, groups|
    service_group = to_group vm[:service]
    groups[service_group] ||= []
    groups[service_group] << vm[:name]
  end
  ansible_groups["#{to_group project_name}:children"] = vms.reduce(Set[]) do |groups, vm|
    groups.add to_group vm[:service]
  end.to_a
  ansible_groups
end

project_name = File.basename __dir__
virtual_machines = [
  {
    name: 'app-1',
    service: 'app',
    primary: true,
    ports: {
      ssh: [10_100, 22],
      http: [10_101, 80]
    }
  },
  # {
  #   name: 'db-1',
  #   service: 'db',
  #   ssh_port: 10_101
  # }
].freeze

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

    # Bento boxes weren't built with EFI enabled, need to fall back to legacy BIOS
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

  virtual_machines.each do |name:, service:, ports:, primary: false|
    config.vm.define name, primary: primary do |inst|
      inst.vm.hostname = name
      ports.each do |id, (host, guest)|
        inst.vm.network 'forwarded_port', id: id, host: host, guest: guest
      end
      inst.vm.provider 'virtualbox' do |vb|
        vb.name = "#{project_name}-#{name}"
        vb.customize ['guestproperty', 'set', :id, '/Project/Service', service]
        vb.customize ['guestproperty', 'set', :id, '/Ansible/Port', ports[:ssh][0].to_s]
      end
    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provisioning/playbooks/site.yml'
    ansible.groups = get_ansible_groups project_name, virtual_machines
  end
end
