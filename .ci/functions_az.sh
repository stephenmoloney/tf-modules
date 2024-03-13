#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091,SC2015

function azure_cli_login() {
    local az_client_id="${1}"
    local az_client_secret="${2}"
    local az_tenant_id="${3}"

    az login \
        --service-principal \
        --username "${az_client_id}" \
        --password "${az_client_secret}" \
        --tenant "${az_tenant_id}"
}

function get_az_ad_application_name() {
    if [[ ! -e ./terraform.auto.tfvars.enc.json ]]; then
        echo "Unexpectedly missing terraform.auto.tfvars.enc.json file" >/dev/stderr
        exit 1
    fi
    jq -r '.azure.az_ad_application_name' <terraform.auto.tfvars.enc.json
}

function get_azure_client_id() {
    az ad app list \
        --display-name "$(get_az_ad_application_name)" \
        --output tsv \
        --query '[0].appId'
}

function get_azure_client_secret() {
    if [[ ! -e ./terraform.auto.tfvars.json ]]; then
        echo "Unexpectedly missing terraform.auto.tfvars.json file" >/dev/stderr
        echo "Ensure that the terraform.auto.tfvars.enc.json file has been decrypted"
        exit 1
    fi
    jq -r .azure.client_secret_enc <terraform.auto.tfvars.json
}

function generate_sas_key() {
    local subscription="${1}"
    local storage_account_name="${2}"

    if [[ -z "${storage_account_name}" ]]; then
        echo "variable storage_account_name must be set" >>/dev/stderr
        exit 1
    fi

    if [[ -z "${subscription}" ]]; then
        echo "variable subscription must be set" >>/dev/stderr
        exit 1
    fi

    az storage account generate-sas \
        --expiry "$(date -d "+1 days" +%Y-%m-%d)"'T00:00:00Z' \
        --permissions "acdlpruw" \
        --resource-types "co" \
        --services "b" \
        --account-name "${storage_account_name}" \
        --https-only \
        --subscription "${subscription}" \
        -o tsv
}

function get_sas_token() {
    local tf_decrypted_file="${1}"
    local subscription_id

    if [[ -z "${tf_decrypted_file}" ]]; then
        tf_decrypted_file=terraform.auto.tfvars.json
    fi

    subscription_id="$(jq -r .azure.subscription_id <"${tf_decrypted_file}")"
    storage_account_name="$(jq -r .terraform_backend.storage_account_name <"${tf_decrypted_file}")"

    generate_sas_key "${subscription_id}" "${storage_account_name}"
}
