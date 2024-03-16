#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091,SC2015,SC2120

function install_asdf() {
    wget -q https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/asdf.sh
    chmod +x ./asdf.sh && ./asdf.sh
    rm ./asdf.sh
    export ASDF_DIR="${HOME}/.asdf"
    source "${HOME}/.asdf/asdf.sh"
}

function install_shfmt() {
    wget https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/shfmt.sh
    chmod +x shfmt.sh
    ./shfmt.sh
    rm ./shfmt.sh
}

function install_node() {
    local node_version="${1:-20.11.1}"

    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs "${node_version}"
    asdf global nodejs "${node_version}"
}

function install_yarn() {
    local yarn_version="${1:-1.22.19}"

    asdf plugin add yarn
    asdf install yarn "${yarn_version}"
    asdf global yarn "${yarn_version}"
}

function install_npm_modules() {
    yarn install --frozen-lockfile --ignore-optional
}

function install_opentofu() {
    local opentofu_version="${1:-1.6.2}"

    asdf plugin add opentofu https://github.com/virtualroot/asdf-opentofu.git
    asdf install opentofu "${opentofu_version}"
    asdf global opentofu "${opentofu_version}"
}

function install_deps() {
    ./.ci/exec_functions.sh install_shfmt
    ./.ci/exec_functions.sh install_asdf
    source "${HOME}/.asdf/asdf.sh"
    (
        ./.ci/exec_functions.sh install_node &&
            ./.ci/exec_functions.sh install_yarn &&
            ./.ci/exec_functions.sh install_npm_modules &&
            ./.ci/exec_functions.sh install_opentofu
    )
}
