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
BUILDDIR ?= build/$(PREFIX)
ifneq "$(GHC_FLAGS)" ""
# We construct a wrapper that always passes GHC_FLAGS to GHC.
# That's more reliable than going through cabal's --ghc-options, for which it
# is unclear whether it applies to the local package or also to all its
# dependencies.
NEWGHC := $(BUILDDIR)/$(PREFIX)
$(shell . $(TOP)/scripts/make-wrapper.sh; makeWrapper '$(GHC)' '$(NEWGHC)' --add-flags '$(GHC_FLAGS)')
GHC := $(NEWGHC)
undefine NEWGHC
endif

CABAL=cabal --with-compiler=$(GHC) --builddir=$(BUILDDIR)
