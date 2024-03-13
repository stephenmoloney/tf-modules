#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091,SC2015

function get_tf_backend_az_resource_group() {
    local tf_decrypted_file="${1}"

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    jq -r .terraform_backend.storage_account_resource_group <"${tf_decrypted_file}"
}

function get_tf_backend_az_storage_account_name() {
    local tf_decrypted_file="${1}"

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    jq -r .terraform_backend.storage_account_name <"${tf_decrypted_file}"
}

function get_tf_backend_az_storage_container_name() {
    local tf_decrypted_file="${1}"

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    jq -r .terraform_backend.storage_container_name <"${tf_decrypted_file}"
}

function get_tf_backend_az_storage_container_key() {
    local tf_decrypted_file="${1}"

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    jq -r .terraform_backend.storage_container_key <"${tf_decrypted_file}"
}

function terraform_decrypt() {
    local kv_key="${1}"
    local tf_encrypted_file="${2}"
    local tf_decrypted_file="${3}"

    if [[ -z "${tf_encrypted_file}" ]]; then
        tf_encrypted_file=terraform.auto.tfvars.enc.json
    fi

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    if [[ -z "${kv_key}" ]]; then
        echo "kv_key is required" >/dev/stderr
    else
        if [[ "${kv_key}" == ".azure.sops_key_vault" ]]; then
            kv_key_arg="--azure-kv"
            kv_key=.azure.sops_key_vault
        else
            kv_key_arg="--pgp"
            kv_key=.sops_pgp_fingerprint
        fi
    fi

    if [[ -f "${tf_encrypted_file}" ]] && [[ -s "${tf_encrypted_file}" ]]; then
        echo "Decrypting ${tf_encrypted_file}"
        sops \
            --verbose \
            --decrypt \
            --input-type json \
            --output-type json \
            --encrypted-suffix _enc \
            "${kv_key_arg}" "$(jq -r "${kv_key}" "${tf_encrypted_file}")" \
            "${tf_encrypted_file}" | jq --sort-keys . >"${tf_decrypted_file}"

        echo "${PWD}/${tf_encrypted_file} has been decrypted to ${PWD}/${tf_decrypted_file}"
    else
        echo "Skipping decryption, ${tf_encrypted_file} does not exist"
    fi

}

function terraform_encrypt() {
    local kv_key="${1}"
    local tf_encrypted_file="${2}"
    local tf_decrypted_file="${3}"
    local kv_key_arg

    if [[ -z "${tf_encrypted_file}" ]]; then
        tf_encrypted_file=terraform.auto.tfvars.enc.json
    fi

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    if [[ -z "${kv_key}" ]]; then
        echo "kv_key is required" >/dev/stderr
    elif [[ "${kv_key}" == ".azure.sops_key_vault" ]]; then
        kv_key_arg="--azure-kv"
    elif [[ "${kv_key}" == ".sops_pgp_fingerprint" ]]; then
        kv_key_arg="--pgp"
    else
        echo "Unexpected kv_key variable ${kv_key}"
    fi

    # shellcheck disable=SC2094
    if [[ -f "${tf_decrypted_file}" ]] && [[ -s "${tf_decrypted_file}" ]]; then
        echo "Encrypting ${tf_decrypted_file}"
        sops \
            --verbose \
            --encrypt \
            --input-type json \
            --output-type json \
            --encrypted-suffix "_enc" \
            "${kv_key_arg}" "$(jq -r "${kv_key}" "${tf_decrypted_file}")" \
            "${tf_decrypted_file}" >"${tf_encrypted_file}"
        echo "${PWD}/${tf_encrypted_file} has been updated"
    else
        echo "Skipping encryption, ${tf_decrypted_file} does not exist"
    fi
}

function tf_init_az_backend() {
    local storage_account_resource_group="${1}"
    local storage_account_name="${2}"
    local storage_container_name="${3}"
    local storage_container_key="${4}"
    local sas_token="${5}"
    local additional_args="${6}"

    if [[ -n "${additional_args}" ]]; then
        tofu init \
            -force-copy \
            -input=false \
            -reconfigure \
            -backend-config "resource_group_name=${storage_account_resource_group}" \
            -backend-config "storage_account_name=${storage_account_name}" \
            -backend-config "container_name=${storage_container_name}" \
            -backend-config "key=${storage_container_key}" \
            -backend-config "sas_token=${sas_token}" \
            "${additional_args}"
    else
        tofu init \
            -force-copy \
            -input=false \
            -reconfigure \
            -backend-config "resource_group_name=${storage_account_resource_group}" \
            -backend-config "storage_account_name=${storage_account_name}" \
            -backend-config "container_name=${storage_container_name}" \
            -backend-config "key=${storage_container_key}" \
            -backend-config "sas_token=${sas_token}"
    fi
}

function tf_upgrade_az_backend() {
    tf_init_az_backend "${1}" "${2}" "${3}" "${4}" "${5}" "-upgrade=true"
}

function tf_init_local_backend() {
    local storage_account_resource_group="${1}"
    local storage_account_name="${2}"
    local storage_container_name="${3}"
    local storage_container_key="${4}"
    local sas_token="${5}"
    local additional_args="${6}"

    if [[ -n "${additional_args}" ]]; then
        tofu init \
            -force-copy \
            -input=false \
            -reconfigure \
            -backend-config "resource_group_name=${storage_account_resource_group}" \
            -backend-config "storage_account_name=${storage_account_name}" \
            -backend-config "container_name=${storage_container_name}" \
            -backend-config "key=${storage_container_key}" \
            -backend-config "sas_token=${sas_token}" \
            "${additional_args}"
    else
        tofu init \
            -force-copy \
            -input=false \
            -reconfigure \
            -backend-config "resource_group_name=${storage_account_resource_group}" \
            -backend-config "storage_account_name=${storage_account_name}" \
            -backend-config "container_name=${storage_container_name}" \
            -backend-config "key=${storage_container_key}" \
            -backend-config "sas_token=${sas_token}"
    fi
}

function tf_upgrade_local_backend() {
    tf_init_az_backend "${1}" "${2}" "${3}" "${4}" "${5}" "-upgrade=true"
}

function tf_plan() {
    local target_resource
    target_resource="${1:-}"

    if [[ -z "${target_resource}" ]]; then
        tofu plan
    else
        tofu plan -target="${target_resource}"
    fi
}

function tf_apply() {
    local target_resource
    target_resource="${1:-}"

    if [[ -z "${target_resource}" ]]; then
        tofu apply --auto-approve
    else
        tofu apply -target="${target_resource}" --auto-approve
    fi
}

function tf_destroy() {
    local target_resource
    target_resource="${1:-}"

    if [[ -z "${target_resource}" ]]; then
        tofu destroy
    else
        tofu destroy -target="${target_resource}"
    fi
}
