include $(TOP)/mk/options.mk

.PHONY : all update build bench clean maintainer-clean

# default targets

all :: update build bench

# head.hackage
HEADHACK=GHC=$(GHC) $(TOP)/head.hackage/scripts/head.hackage.sh
cabal.project.local :
	rm -rf cabal.project.local
	$(HEADHACK) init-local

update :: cabal.project.local
	$(CABAL) v2-update

build :: | update
	$(CABAL) v2-build --disable-tests all:benchmarks

clean ::
	rm -rf $(BUILDDIR)
	rm -rf $(LOGDIR)
maintainer-clean :: clean
	rm -rf cabal.project.local

# bench is defined in epilog.mk
