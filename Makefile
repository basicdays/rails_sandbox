bundle=bin/bundle
cap=bin/cap

tmp/ansible-installed: provisioning/requirements.yml
	ansible-galaxy install -r provisioning/requirements.yml
	@touch tmp/ansible-installed

setup: tmp/ansible-installed

ansible-lint:
	@ansible-playbook -i provisioning/inventories/local --syntax-check provisioning/playbooks/site.yml
	@ansible-lint provisioning/playbooks/site.yml

ansible-inventory:
	@ansible-inventory -i provisioning/inventories/local --graph

ansible-inventory-data:
	@ansible-inventory -i provisioning/inventories/local --list

ansible-provision:
	@ansible-playbook \
		-i provisioning/inventories/local \
		provisioning/playbooks/site.yml

ansible-facts:
	@ansible \
		-i provisioning/inventories/local \
		-m ansible.builtin.setup \
		rails_sandbox

vagrant-provision:
	vagrant up --provision

update-bundle-cache:
	$(bundle) cache --all-platforms

deploy-vbox:
	$(cap) vbox deploy
