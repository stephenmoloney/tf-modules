#!/usr/bin/env bash
# shellcheck shell=bash disable=SC1094,SC1090,SC1091

set -e
set -o pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/functions.sh"
"$@"
