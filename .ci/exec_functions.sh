#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1094,SC1090,SC1091,SC2044

set -x
set -e
set -o pipefail

scripts_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for f in $(find "${scripts_path}" -type f -name 'functions_*.sh'); do
    source "${f}"
done

"$@"
