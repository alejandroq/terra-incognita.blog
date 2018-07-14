# Container meta-info
BIN := hugo
REGISTRY ?= alejandroq
    IMAGE := $(REGISTRY)/$(BIN)
CONTAINER := $(REGISTRY)-$(BIN)

# Rebuild the docker container
# Must be run from the directory containing the Dockerfile
buildimage:
	@docker build -t $(IMAGE) .

#
# Docker commands
#
status:
	@docker ps --filter="name=$(CONTAINER)"

stop:
	@docker kill $(shell docker ps --filter=\"name=$(CONTAINER)\" -q) > /dev/null 2>&1 || true
