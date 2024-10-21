TERRAFORM_DIR = terraform/app
TERRAFORM_VERSION = 1.9.8
INSTALL_DIR = $(WORKSPACE)/terraform
TERRAFORM_BIN = $(INSTALL_DIR)/terraform_installed

install:
	mkdir -p $(INSTALL_DIR)
	if ! terraform -version | grep -q $(TERRAFORM_VERSION); then \
		curl -o terraform.zip https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip; \
		unzip terraform.zip -d $(INSTALL_DIR); \
		mv $(INSTALL_DIR)/terraform $(TERRAFORM_BIN); \
	fi


init: install
	cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) init

plan: init
	cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) plan -var-file=terraform/vars/sandbox.tfvars

apply: plan
	cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) apply -var-file=terraform/vars/sandbox.tfvars -auto-approve
