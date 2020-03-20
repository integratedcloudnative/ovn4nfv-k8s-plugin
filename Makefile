# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2018 Intel Corporation
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
SHELL:=/bin/bash
GOPATH := $(shell realpath "$(PWD)/../../")
DOCKERBUILD := $(CURDIR)/build 

export GOPATH ...
export GO111MODULE=on

.PHONY: all 
all: clean nfn-operator ovn4nfvk8s-cni nfn-agent docker

nfn-operator:
	@go build -o build/bin/nfn-operator ./cmd/nfn-operator

ovn4nfvk8s-cni:
	@go build -o build/bin/ovn4nfvk8s-cni ./cmd/ovn4nfvk8s-cni

nfn-agent:
	@go build -o build/bin/nfn-agent ./cmd/nfn-agent

docker:
	@pushd $(DOCKERBUILD) && \
	docker build --rm -t \
	integratedcloudnative/ovn4nfv-k8s-plugin:master . -f Dockerfile	&& \
	popd

test:
	@go test -v ./...

clean:
	@rm -f build/bin/ovn4nfvk8s*
	@rm -f build/bin/nfn-operator*
	@rm -f build/bin/nfn-agent*
	@if [[ "$$(docker images -q integratedcloudnative/ovn4nfv-k8s-plugin:master 2> /dev/null)" !=  "" ]]; then \
	    	docker rmi integratedcloudnative/ovn4nfv-k8s-plugin:master; \
        fi
