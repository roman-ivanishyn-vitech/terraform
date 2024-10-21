# Variables
TERRAFORM_DIR = terraform/app
TERRAFORM_VERSION = 1.9.8
INSTALL_DIR = $(WORKSPACE)/terraform
TERRAFORM_BIN = $(INSTALL_DIR)/terraform_installed

# Target to install Terraform if not already installed
install:
	@mkdir -p $(INSTALL_DIR)
	@if ! command -v $(TERRAFORM_BIN) &> /dev/null; then \
		echo "Installing Terraform version $(TERRAFORM_VERSION)..."; \
		curl -o terraform.zip https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip; \
		unzip terraform.zip -d $(INSTALL_DIR); \
		mv $(INSTALL_DIR)/terraform $(TERRAFORM_BIN); \
		echo "Terraform installed at $(TERRAFORM_BIN)"; \
	fi

# Initialize Terraform
init: install
	@echo "Initializing Terraform..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) init

# Plan Terraform changes
plan: init
	@echo "Planning Terraform changes..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) plan -var-file=terraform/vars/sandbox.tfvars

# Apply Terraform changes
apply: plan
	@echo "Applying Terraform changes..."
	@cd $(TERRAFORM_DIR) && $(TERRAFORM_BIN) apply -var-file=terraform/vars/sandbox.tfvars -auto-approve
