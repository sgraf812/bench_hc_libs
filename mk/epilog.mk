ifneq "$(BENCHMARKS)" ""

bench :: | build
	@echo "Benchmarking " $(BENCHMARKS)
	@$(foreach bench, $(BENCHMARKS), mkdir -p $(LOGDIR)/$(bench); $(shell find $(BUILDDIR) -path "*/$(bench)/$(bench)" -type f) --csv="$(LOGDIR)/$(bench)/$(PREFIX).csv";)

endif

include $(TOP)/mk/recurse.mk
