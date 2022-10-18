setup:
	@ansible-galaxy install -r requirements.yml

lint:
	@ansible-playbook -i inventories/local --syntax-check playbooks/site.yml
	@ansible-lint playbooks/site.yml

list-inventory:
	@ansible-inventory -i inventories/local --graph

list-inventory-data:
	@ansible-inventory -i inventories/local --list

run:
	@ansible-playbook \
		-i inventories/local \
		playbooks/site.yml

facts:
	@ansible \
		-i inventories/local \
		-m ansible.builtin.setup \
		rails_sandbox
