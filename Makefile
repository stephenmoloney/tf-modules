SHELL := /bin/bash

.PHONY: \
	install_deps \
	format \
	lint

install_deps:
	./.ci/exec_functions.sh install_all_deps

format:
	./.ci/exec_functions.sh format_markdown
	./.ci/exec_functions.sh format_shell
	./.ci/exec_functions.sh format_tofu

lint:
	./.ci/exec_functions.sh lint_markdown
	./.ci/exec_functions.sh lint_shell
	./.ci/exec_functions.sh lint_tofu
	pushd examples/az-resource-groups; make init_local_backend; popd
