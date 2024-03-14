#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091,SC2015

function install_asdf() {
    wget -q https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/asdf.sh
    chmod +x ./asdf.sh && ./asdf.sh
    export ASDF_DIR="${HOME}/.asdf" && source "${HOME}/.asdf/asdf.sh"
}

function install_node() {
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs 16.14.2
    asdf global nodejs 16.14.2
}

function install_yarn() {
    asdf plugin add yarn
    asdf install yarn 1.22.18
    asdf global yarn 1.22.18
}

function install_npm_modules() {
    yarn install --frozen-lockfile --ignore-optional
}

function install_opentofu() {
    asdf plugin add opentofu https://github.com/virtualroot/asdf-opentofu.git
    asdf install opentofu latest
    asdf global opentofu latest
}

function install_all_deps() {
    install_asdf &&
        (
            install_node
            install_yarn
            install_npm_modules
            install_opentofu
        )
}
