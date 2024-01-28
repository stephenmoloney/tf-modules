SHELL := /bin/bash

.PHONY: \
	format \
	lint

format:
	./.ci/source_functions.sh format_shell
	./.ci/source_functions.sh format_tofu

lint:
	./.ci/source_functions.sh lint_shell
	./.ci/source_functions.sh lint_tofu
