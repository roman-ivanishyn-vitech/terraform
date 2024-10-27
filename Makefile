TERRAFORM_DIR = terraform/backend
TERRAFORM_VERSION = 1.9.8
INSTALL_DIR = $(WORKSPACE)/terraform
TERRAFORM_BIN = $(INSTALL_DIR)/terraform_installed

install:
	@mkdir -p $(INSTALL_DIR)
	@if ! command -v $(TERRAFORM_BIN) &> /dev/null; then \
		echo "Installing Terraform version $(TERRAFORM_VERSION)..."; \
		curl -o terraform.zip https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip; \
		unzip terraform.zip -d $(INSTALL_DIR); \
		mv $(INSTALL_DIR)/terraform $(TERRAFORM_BIN); \
		echo "Terraform installed at $(TERRAFORM_BIN)"; \
	fi

init: install
	@echo "Initializing Terraform..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) init -var-file=terraform/vars/sandbox.tfvars

plan:
	@echo "Planning Terraform changes..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) plan -var-file=terraform/vars/sandbox.tfvars

apply: plan
	@echo "Applying Terraform changes..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) apply -var-file=terraform/vars/sandbox.tfvars -auto-approve
