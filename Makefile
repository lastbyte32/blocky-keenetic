SHELL := /bin/bash

VERSION := $(shell cat VERSION)
ROOT_DIR := /opt

include repo.mk
include packages.mk

.PHONY: clean
clean:
	rm -rf out/blocky out/blocky.tar.gz
	$(MAKE) _repo-clean
	$(MAKE) _clean

.PHONY: all
all: aarch64

.PHONY: aarch64
aarch64:
	$(MAKE) _download_bins ARCH=aarch64-3.10
	$(MAKE) _ipk ARCH=aarch64-3.10 BUILD_DIR=aarch64 FILENAME=blocky-keenetic_$(VERSION)_aarch64-3.10.ipk
	$(MAKE) _repository ARCH=aarch64-3.10 BUILD_DIR=aarch64 FILENAME=blocky-keenetic_$(VERSION)_aarch64-3.10.ipk