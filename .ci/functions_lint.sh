#!/usr/bin/env bash
# shellcheck disable=SC2061,SC2035,SC2044

function format_shell() {
    for f in $(
        find . -type f -name "*.sh" \
            -not \( -path "*/node_modules/*" -prune \) \
            -not \( -path "*/.terraform/*" -prune \)
    ); do
        shfmt -l -w "${f}"
    done
}

function format_markdown() {
    for f in $(
        find . -type f -name "*.md" \
            -not \( -path "*/node_modules/*" -prune \) \
            -not \( -path "*/.terraform/*" -prune \)
    ); do
        yarn prettier --write "${f}"
    done
}

function format_tofu() {
    tofu fmt --recursive
}

function format_all() {
    format_markdown
    format_shell
    format_tofu
}

function lint_markdown() {
    for f in $(
        find . -type f -name "*.md" \
            -not \( -path "*/node_modules/**" -prune \) \
            -not \( -path "*/.terraform/**" -prune \)
    ); do
        yarn markdownlint-cli2 "${f}" "#node_modules"
    done
    for f in $(
        find . -type f -name "*.md" \
            -not \( -path "*/node_modules/**" -prune \) \
            -not \( -path "*/.terraform/**" -prune \)
    ); do
        yarn prettier --check "${f}"
    done
}

function lint_shell() {
    find . -type f -name "*.sh" -exec shfmt -l -d {} +
    find . -type f -name "*.sh" -exec shellcheck -x {} +
}

function lint_tofu() {
    local tf_projs
    readarray -t tf_projs < <(find ./examples -mindepth 1 -maxdepth 1 -type d)

    for tf_proj in "${tf_projs[@]}"; do
        if [[ -n "$(find ./"${tf_proj}" -name *.tf)" ]]; then
            pushd "${tf_proj}" >/dev/null || return
            if [[ -d .terraform ]]; then rm -rf .terraform; fi
            if [[ -e .terraform.lock.hcl ]]; then rm .terraform.lock.hcl; fi
            tofu init -backend=false >/dev/null || (popd >/dev/null || return)
            tofu validate || (popd >/dev/null || return)
            popd >/dev/null || return
        fi
    done
}
