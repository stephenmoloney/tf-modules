#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1090,SC1091,SC2015

function install_asdf() {
    wget -q https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/asdf.sh
    chmod +x ./asdf.sh && ./asdf.sh
    export ASDF_DIR="${HOME}/.asdf" && source "${HOME}/.asdf/asdf.sh"
}

function install_shfmt() {
    wget -O - https://raw.githubusercontent.com/stephenmoloney/localbox/changed/go-installation/bin/install/go.sh | bash
    wget -O - https://raw.githubusercontent.com/stephenmoloney/localbox/master/bin/install/shfmt.sh | bash
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

#function install_golang() {
#    local release=$1
#
#    if [[ -z "${release}" ]]; then
#        release=1.20.4
#    fi
#
#    if [ -z "$(command -v wget)" ]; then
#        sudo apt-get install -y -qq wget
#    fi
#
#    wget --quiet "https://dl.google.com/go/go${release}.linux-amd64.tar.gz"
#
#    if [[ -d /usr/local/go ]]; then
#        sudo rm -R /usr/local/go
#    fi
#
#    sudo tar -C /usr/local -xzf "go${release}.linux-amd64.tar.gz" &&
#        echo "export PATH=$PATH:/usr/local/go/bin" >>"${HOME}/.bash_profile" &&
#        echo "export GOPATH=${HOME}/go" >>"${HOME}/.bash_profile" &&
#        echo "export GOROOT=/usr/local/go" >>"${HOME}/.bash_profile" &&
#        source "${HOME}/.bash_profile" &&
#        go version
#}

function install_all_deps() {
#    install_golang
    install_shfmt
    install_asdf &&
        (
            install_node
            install_yarn
            install_npm_modules
            install_opentofu
        )
}
