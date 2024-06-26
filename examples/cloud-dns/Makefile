SHELL := /bin/bash
GIT_ROOT_DIR := $(shell git rev-parse --show-toplevel)
ENCRYPTED_FILE := terraform.auto.tfvars.enc.json
ENCRYPTED_FILE_PATH := $(CURDIR)/$(ENCRYPTED_FILE)
DECRYPTED_FILE := terraform.auto.tfvars.json
DECRYPTED_FILE_PATH := $(CURDIR)/$(DECRYPTED_FILE)

.PHONY: \
	sops_decrypt \
	sops_encrypt \
	print_params \
    init_backend \
    upgrade_backend \
    plan \
    apply

sops_decrypt:
	@echo "Commencing decrpytion of $(ENCRYPTED_FILE_PATH)"
	@echo $(GIT_ROOT_DIR)
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh terraform_decrypt ".sops_pgp_fingerprint"

sops_encrypt:
	@echo "Commencing encrpytion of $(CURDIR)/$(ENCRYPTED_FILE)"
	@echo $(GIT_ROOT_DIR)
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh terraform_encrypt ".sops_pgp_fingerprint"

print_params:
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_resource_group
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_account_name
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_name
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_key
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh get_sas_token

init_local_backend:
	rm -rf .terraform
	tofu init -cloud=false

upgrade_local_backend:
	rm -rf .terraform
	rm .terraform.lock.hcl
	tofu init -cloud=false -upgrade

init_backend:
	rm -rf .terraform
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh tf_init_az_backend \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_resource_group) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_account_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_key) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_sas_token)

upgrade_backend:
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh tf_upgrade_az_backend \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_resource_group) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_account_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_key) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_sas_token)

plan:
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh tf_plan

apply:
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh tf_apply
