SHELL := /bin/bash
GIT_ROOT_DIR := $(shell git rev-parse --show-toplevel)
ENCRYPTED_FILE := terraform.auto.tfvars.enc.json
ENCRYPTED_FILE_PATH := $(CURDIR)/$(ENCRYPTED_FILE)
DECRYPTED_FILE := terraform.auto.tfvars.json
DECRYPTED_FILE_PATH := $(CURDIR)/$(DECRYPTED_FILE)

.PHONY: \
	sops_decrypt \
	sops_encrypt \
	init_local_backend \
	init_az_backend \
	upgrade_local_backend \
	upgrade_az_backend \
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

init_local_backend:
	rm -rf .terraform
	tofu init -cloud=false

init_az_backend:
	rm -rf .terraform
	tofu init
	@$(GIT_ROOT_DIR)/.ci/exec_functions.sh tf_init_az_backend \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_resource_group) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_account_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_name) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_tf_backend_az_storage_container_key) \
		$$($(GIT_ROOT_DIR)/.ci/exec_functions.sh get_sas_token)

upgrade_local_backend:
	rm -rf .terraform
	rm .terraform.lock.hcl
	tofu init -cloud=false -upgrade

upgrade_az_backend:
	rm -rf .terraform
	rm .terraform.lock.hcl
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
