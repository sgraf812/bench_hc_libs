SHELL := bash

# Constant global options
LOGDIR ?= logs

# Configurable global options
GHC ?= $(shell which ghc)
GHC_FLAGS ?=
ifeq "$(GHC_FLAGS)" ""
# No need to uglify PREFIX with a trailing underscore
PREFIX ?= $(shell printf %q '$(shell $(GHC) --numeric-version)')
else
PREFIX ?= $(shell printf %q '$(shell $(GHC) --numeric-version)_$(GHC_FLAGS)')
endif
BUILDDIR ?= $(PREFIX)

CABAL=cabal --with-compiler=$(GHC) --ghc-options=$(GHC_FLAGS) --builddir=$(BUILDDIR)
