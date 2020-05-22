##################################################################
#
# 		Recursive stuff
#
##################################################################

# SG: This is some smartness which originates in fptools, I guess.
# I just copied it over from nofib (mk/ghc-recurse.mk) and modified
# it to fit my needs.

# Here are the diabolically clever rules that for each "recursive target" <t>
# propagates "make <t>" to directories in SUBDIRS
#
# Controlling variables
# 	SUBDIRS = subdirectories to recurse into

# note about recursively invoking make: we'd like make to drop all the
# way back to the top level if it fails in any of the
# sub(sub-...)directories.  This is done by setting the -e flag to the
# shell during the loop, which causes an immediate failure if any of
# the shell commands fail.

# One exception: if the user gave the -i or -k flag to make in the
# first place, we'd like to reverse this behaviour.  So we check for
# these flags, and set the -e flag appropriately.  NOTE: watch out for
# the --no-print-directory flag which is passed to recursive
# invocations of make.

ifneq "$(SUBDIRS)" ""

all update build bench clean maintainer-clean ::
	@echo "------------------------------------------------------------------------"
	@echo "== Recursively making \`$@' in $(SUBDIRS) ..."
	@echo "PWD = $(shell pwd)"
	@echo "------------------------------------------------------------------------"
# Don't rely on -e working, instead we check exit return codes from sub-makes.
	@case '${MAKEFLAGS}' in *-[ik]*) x_on_err=0;; *-r*[ik]*) x_on_err=0;; *) x_on_err=1;; esac; \
	if [ $$x_on_err -eq 0 ]; \
	    then echo "Won't exit on error due to MAKEFLAGS: ${MAKEFLAGS}"; \
	fi; \
	for i in $(SUBDIRS); do \
	  echo "------------------------------------------------------------------------"; \
	  echo "== $(MAKE) $@ $(MAKEFLAGS);"; \
	  echo " in $(shell pwd)/$$i"; \
	  echo "------------------------------------------------------------------------"; \
	  $(MAKE) --no-print-directory -C $$i $(MAKEFLAGS) $@ CLEAN_ALL_STAGES=YES; \
	  if [ $$? -eq 0 -o $$x_on_err -eq 0 ]; \
	      then echo "Finished making $@ in $$i": $$?; \
	      else echo "Failed making $@ in $$i": $$?; exit 1; \
	  fi; \
	done
	@echo "------------------------------------------------------------------------"
	@echo "== Finished making \`$@' in $(SUBDIRS) ..."
	@echo "PWD = $(shell pwd)"
	@echo "------------------------------------------------------------------------"

#
# Selectively building subdirectories.
#
#
$(SUBDIRS) ::
	  $(MAKE) -C $@ $(MAKEFLAGS)

endif
