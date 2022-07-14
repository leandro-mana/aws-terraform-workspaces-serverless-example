# Globals
.PHONY: help cicd_local_env cfn/% tf/% pylint mypy pytest
.DEFAULT: help
.ONESHELL:
.SILENT:
SHELL=/bin/bash
.SHELLFLAGS = -ceo pipefail

# Supported Environments
ENVS = dev qa prod

# Targets
DEPLOY_TARGET = Deploy Target
CICD_LOCAL_ENV_TARGET = Run CICD Docker Image

# Colours for Help Message and INFO formatting
YELLOW := "\e[1;33m"
NC := "\e[0m"
INFO := @bash -c 'printf $(YELLOW); echo "=> $$0"; printf $(NC)'
export 

help:
	$(INFO) "Run: make <target>"
	$(INFO) "Supported Environments: $$ENVS"
	$(INFO) "List of Supported Targets:"
	@echo -e "pylint -> Python Linter"
	@echo -e "mypy   -> MyPy Code Check"
	@echo -e "test   -> pylint, mypy and PyTest"
	@echo -e "tf/fmt -> Terraform formatter\n"

tf/fmt:
	$(INFO) "Terraform Recursive Format"
	terraform fmt -recursive terraform

pylint:
	$(INFO) "Pylint"
	pylint src/

mypy:
	$(INFO) "MyPy"
	mypy src/

test: pylint mypy
	$(INFO) "Pyliny, MyPy, PyTest"
	pytest test
