# frozen_string_literal: true

def to_group(name)
  name.gsub('-', '_')
end

def to_hostname(name)
  name.gsub('_', '-')
end

def get_ansible_groups(project_name, vms)
  ansible_groups = vms.each_with_object({}) do |vm, groups|
    service_group = to_group(vm[:service])
    groups[service_group] ||= []
    groups[service_group] << vm[:name]
  end
  ansible_groups["#{to_group(project_name)}:children"] = vms.reduce(Set[]) do |groups, vm|
    groups.add(to_group(vm[:service]))
  end.to_a
  ansible_groups
end

project_name = File.basename(__dir__)
virtual_machines = [
  {
    name: 'app-1',
    service: 'app',
    primary: true,
    ip: '10.10.10.2',
    ports: {
      ssh: [10_160, 22],
      http: [10_150, 80]
    }
  },
  {
    name: 'db-1',
    service: 'db',
    ip: '10.10.10.3',
    ports: {
      ssh: [10_161, 22],
      postgresql: [10_151, 5432]
    }
  },
  # {
  #   name: 'cache-1',
  #   service: 'cache',
  #   ports: {
  #     ssh: [10_161, 22],
  #     redis: [10_151, 6379]
  #   }
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

    vb.customize ['guestproperty', 'set', :id, '/Ansible/Host', 'localhost']
    vb.customize ['guestproperty', 'set', :id, '/Ansible/User', 'vagrant']
    vb.customize ['guestproperty', 'set', :id, '/Project/Name', project_name]
  end

  host_vars = {}
  virtual_machines.each do |name:, service:, ip:, ports:, primary: false|
    hostname = to_hostname(name)

    config.vm.define hostname, primary: primary do |inst|
      inst.vm.hostname = hostname

      ports.each do |id, (host, guest)|
        inst.vm.network 'forwarded_port', id: id, host: host, guest: guest
      end
      # allow vms to communicate with each other
      inst.vm.network 'private_network', ip: ip, virtualbox__intnet: project_name

      inst.vm.provider 'virtualbox' do |vb|
        vb.name = to_hostname("#{project_name}-#{hostname}")
        vb.customize ['guestproperty', 'set', :id, '/Ansible/Port', ports[:ssh][0].to_s]
        vb.customize ['guestproperty', 'set', :id, '/Project/Hostname', hostname]
        vb.customize ['guestproperty', 'set', :id, '/Project/InternalIP', ip]
        vb.customize ['guestproperty', 'set', :id, '/Project/Service', service]
      end

      host_vars[hostname] = {
        'project_hostname': hostname,
        'project_internal_ip': ip,
        'project_name': project_name,
        'project_service': service
      }
    end
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provisioning/playbooks/site.yml'
    ansible.groups = get_ansible_groups(project_name, virtual_machines)
    ansible.host_vars = host_vars
  end
end
