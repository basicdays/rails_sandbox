setup:
	@ansible-galaxy install -r provisioning/requirements.yml

lint:
	@ansible-playbook -i provisioning/inventories/local --syntax-check provisioning/playbooks/site.yml
	@ansible-lint provisioning/playbooks/site.yml

list-inventory:
	@ansible-inventory -i provisioning/inventories/local --graph

list-inventory-data:
	@ansible-inventory -i provisioning/inventories/local --list

provision:
	@ansible-playbook \
		-i provisioning/inventories/local \
		provisioning/playbooks/site.yml

ansible-facts:
	@ansible \
		-i provisioning/inventories/local \
		-m ansible.builtin.setup \
		rails_sandbox
