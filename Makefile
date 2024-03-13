SHELL := /bin/bash

.PHONY: \
	format \
	lint

format:
	./.ci/exec_functions.sh format_markdown
	./.ci/exec_functions.sh format_shell
	./.ci/exec_functions.sh format_tofu

lint:
	./.ci/exec_functions.sh lint_markdown
	./.ci/exec_functions.sh lint_shell
	./.ci/exec_functions.sh lint_tofu
	pushd examples/az-resource-groups; make init_local_backend; popd
