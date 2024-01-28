#!/usr/bin/env bash
# shellcheck disable=SC2061,SC2035

function format_shell() {
    find . -type f -name "*.sh" -exec shfmt -l -w {} +
}

function format_tofu() {
    tofu fmt --recursive
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
            tofu init -backend=false >/dev/null 2>/dev/null || (popd >/dev/null || return)
            tofu validate || (popd >/dev/null || return)
            popd >/dev/null || return
        fi
    done
}
