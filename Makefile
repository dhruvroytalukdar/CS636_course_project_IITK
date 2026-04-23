CXX         := clang++
OPT         := opt
LLVM_CONFIG := llvm-config

LLVM_LIBDIR := $(shell $(LLVM_CONFIG) --libdir)
LIBCPP_DIR  := $(shell dirname $$(find $(LLVM_LIBDIR) -name "libc++.so.1" 2>/dev/null | head -n 1))
CXXFLAGS    := $(shell $(LLVM_CONFIG) --cxxflags)
LDFLAGS     := $(shell $(LLVM_CONFIG) --ldflags) -Wl,-rpath=$(LLVM_LIBDIR) -Wl,-rpath=$(LIBCPP_DIR)
TSAN_FLAGS  := -fsanitize=thread -g -O1

# ──────────────────────────────────────────────────────────────────
# SOURCE FILES
# ──────────────────────────────────────────────────────────────────
# The FT instrumentation pass is reused unchanged — the WCP runtimes
# expose __ft_* symbols that forward to their __wcp_* implementations,
# so no new LLVM pass is needed.
PASS_SRC        := fasttrack_instrumentation.cpp
PASS_NAME       := fasttrack-pass

ESCAPE_PASS_SRC := escape_instrumentation.cpp

RUNTIME_WCP     := wcp_runtime.cpp
RUNTIME_WCP_SA  := wcp_runtime_with_sa.cpp

TARGET_SRC      := ./testing_temp_dir/src/test.cpp
# TARGET_SRC    := ./targets/old_targets_dhruv/test_efficiency.cpp

BUILD_DIR       := build_wcp
TARGET_NAME     := $(notdir $(basename $(TARGET_SRC)))

# ──────────────────────────────────────────────────────────────────
# DERIVED PATHS  (all inside BUILD_DIR)
# ──────────────────────────────────────────────────────────────────
PLUGIN          := $(BUILD_DIR)/llvmpass.so
ESCAPE_PASS_OBJ := $(BUILD_DIR)/escape_instpass.so

TARGET_BC       := $(BUILD_DIR)/$(TARGET_NAME).bc
TARGET_INST_BC  := $(BUILD_DIR)/$(TARGET_NAME)_inst.bc
TARGET_LL       := $(BUILD_DIR)/$(TARGET_NAME).ll

RUNTIME_WCP_OBJ    := $(BUILD_DIR)/runtime_wcp.o
RUNTIME_WCP_SA_OBJ := $(BUILD_DIR)/runtime_wcp_sa.o

# FT-pass instrumented binaries
BENCH_TSAN      := $(BUILD_DIR)/bench_tsan
BENCH_WCP       := $(BUILD_DIR)/bench_wcp
BENCH_WCP_SA    := $(BUILD_DIR)/bench_wcp_sa

# Escape-pass instrumented binaries
ESCAPE_IR          := $(BUILD_DIR)/instrumented_escape.ll
ESCAPE_EXEC_WCP    := $(BUILD_DIR)/instrumented_escape_wcp
ESCAPE_EXEC_WCP_SA := $(BUILD_DIR)/instrumented_escape_wcp_sa

# Output logs
OUT_TSAN           := $(BUILD_DIR)/out_tsan.txt
OUT_WCP            := $(BUILD_DIR)/out_wcp.txt
OUT_WCP_SA         := $(BUILD_DIR)/out_wcp_sa.txt
OUT_ESCAPE_WCP     := $(BUILD_DIR)/out_escape_wcp.txt
OUT_ESCAPE_WCP_SA  := $(BUILD_DIR)/out_escape_wcp_sa.txt

# ──────────────────────────────────────────────────────────────────
# DEFAULT TARGET
# ──────────────────────────────────────────────────────────────────
all: $(BENCH_WCP) $(BENCH_WCP_SA)

# ──────────────────────────────────────────────────────────────────
# DIRECTORY GUARD
# ──────────────────────────────────────────────────────────────────
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# ──────────────────────────────────────────────────────────────────
# [0] TSAN BASELINE
# ──────────────────────────────────────────────────────────────────
$(BENCH_TSAN): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[0] Compiling TSAN baseline..."
	$(CXX) $(TSAN_FLAGS) $(TARGET_SRC) -o $@ -lpthread

bench_tsan: $(BENCH_TSAN)

# ──────────────────────────────────────────────────────────────────
# [1] LLVM PASS PLUGIN
# ──────────────────────────────────────────────────────────────────
$(PLUGIN): $(PASS_SRC) | $(BUILD_DIR)
	@echo "[1] Building FastTrack LLVM pass..."
	$(CXX) -fPIC -shared $(PASS_SRC) -o $@ $(CXXFLAGS) $(LDFLAGS)

# ──────────────────────────────────────────────────────────────────
# [2] COMPILE TARGET TO BITCODE
# ──────────────────────────────────────────────────────────────────
$(TARGET_BC): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[2] Compiling target to bitcode..."
	$(CXX) -emit-llvm -O0 -fno-inline -fno-builtin \
	       -fno-omit-frame-pointer -g \
	       -c $(TARGET_SRC) -o $@

# ──────────────────────────────────────────────────────────────────
# [2b] HUMAN-READABLE IR
# ──────────────────────────────────────────────────────────────────
$(TARGET_LL): $(TARGET_SRC) | $(BUILD_DIR)
	@echo "[2b] Generating human-readable LLVM IR..."
	$(CXX) -S -emit-llvm -g $(TARGET_SRC) -o $@

target_ir: $(TARGET_LL)

# ──────────────────────────────────────────────────────────────────
# [3] INSTRUMENT BITCODE (reuses the FT pass — WCP runtimes provide
#     __ft_* aliases so the same instrumented bitcode works for both)
# ──────────────────────────────────────────────────────────────────
$(TARGET_INST_BC): $(TARGET_BC) $(PLUGIN)
	@echo "[3] Instrumenting bitcode with pass..."
	$(OPT) -load-pass-plugin=./$(PLUGIN) \
	       -passes="default<O0>,$(PASS_NAME)" \
	       $(TARGET_BC) -o $@

# ──────────────────────────────────────────────────────────────────
# [4] RUNTIME OBJECTS
# ──────────────────────────────────────────────────────────────────
$(RUNTIME_WCP_OBJ): $(RUNTIME_WCP) | $(BUILD_DIR)
	@echo "[4a] Compiling plain WCP runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_WCP) -o $@

$(RUNTIME_WCP_SA_OBJ): $(RUNTIME_WCP_SA) | $(BUILD_DIR)
	@echo "[4b] Compiling WCP+SA runtime..."
	$(CXX) -O0 -g -c $(RUNTIME_WCP_SA) -o $@

# ──────────────────────────────────────────────────────────────────
# [5] LINK BENCHMARKS
# ──────────────────────────────────────────────────────────────────
$(BENCH_WCP): $(TARGET_INST_BC) $(RUNTIME_WCP_OBJ)
	@echo "[5a] Linking bench_wcp..."
	$(CXX) $^ -o $@ -lpthread

$(BENCH_WCP_SA): $(TARGET_INST_BC) $(RUNTIME_WCP_SA_OBJ)
	@echo "[5b] Linking bench_wcp_sa..."
	$(CXX) $^ -o $@ -lpthread

# ──────────────────────────────────────────────────────────────────
# [6] ESCAPE ANALYSIS PASS + INSTRUMENTED BINARIES
# ──────────────────────────────────────────────────────────────────
$(ESCAPE_PASS_OBJ): $(ESCAPE_PASS_SRC) | $(BUILD_DIR)
	@echo "[6] Building Escape Analysis LLVM pass..."
	$(CXX) -shared -fPIC $(CXXFLAGS) $(LDFLAGS) $< -o $@

$(ESCAPE_IR): $(TARGET_BC) $(ESCAPE_PASS_OBJ)
	@echo "[7] Instrumenting bitcode with Escape Analysis pass..."
	$(OPT) -load-pass-plugin=./$(ESCAPE_PASS_OBJ) \
	       -passes="shared-ptr-analysis" $< -S -o $@

$(ESCAPE_EXEC_WCP): $(ESCAPE_IR) $(RUNTIME_WCP_OBJ)
	@echo "[8a] Linking escape_wcp..."
	$(CXX) $^ -o $@ -lpthread

$(ESCAPE_EXEC_WCP_SA): $(ESCAPE_IR) $(RUNTIME_WCP_SA_OBJ)
	@echo "[8b] Linking escape_wcp_sa..."
	$(CXX) $^ -o $@ -lpthread

instrument_escape: $(ESCAPE_EXEC_WCP) $(ESCAPE_EXEC_WCP_SA)

# ──────────────────────────────────────────────────────────────────
# RUN — execute all 4 variants and compare
# ──────────────────────────────────────────────────────────────────
run: $(BENCH_WCP) $(BENCH_WCP_SA) $(ESCAPE_EXEC_WCP) $(ESCAPE_EXEC_WCP_SA)
	@echo "Using LLVM from: $$(which clang++)"

	@echo ""
	@echo "====== Plain WCP ======"
	./$(BENCH_WCP) 2>&1 | tee $(OUT_WCP)

	@echo ""
	@echo "====== WCP + Sharing Analysis ======"
	./$(BENCH_WCP_SA) 2>&1 | tee $(OUT_WCP_SA)

	@echo ""
	@echo "====== Escape Analysis + WCP ======"
	./$(ESCAPE_EXEC_WCP) 2>&1 | tee $(OUT_ESCAPE_WCP)

	@echo ""
	@echo "====== Escape Analysis + WCP + SA ======"
	./$(ESCAPE_EXEC_WCP_SA) 2>&1 | tee $(OUT_ESCAPE_WCP_SA)

	@echo ""
	@echo "====== Race Report Counts ======"
	@WC=$$(grep  -c 'WCP.*LOG' $(OUT_WCP)            2>/dev/null || echo 0); \
	 WS=$$(grep  -c 'WCP.*LOG' $(OUT_WCP_SA)         2>/dev/null || echo 0); \
	 EW=$$(grep  -c 'WCP.*LOG' $(OUT_ESCAPE_WCP)     2>/dev/null || echo 0); \
	 EWS=$$(grep -c 'WCP.*LOG' $(OUT_ESCAPE_WCP_SA)  2>/dev/null || echo 0); \
	 echo "  plain WCP         : $${WC}"; \
	 echo "  WCP + SA          : $${WS}"; \
	 echo "  escape WCP        : $${EW}"; \
	 echo "  escape + WCP + SA : $${EWS}"

	@echo ""
	@echo "====== Unique Race Locations ======"
	@grep '^\[UNIQUE_RACES\]' $(OUT_WCP)           2>/dev/null | sed 's/^/  plain WCP         : /'
	@grep '^\[UNIQUE_RACES\]' $(OUT_WCP_SA)        2>/dev/null | sed 's/^/  WCP + SA          : /'
	@grep '^\[UNIQUE_RACES\]' $(OUT_ESCAPE_WCP)    2>/dev/null | sed 's/^/  escape WCP        : /'
	@grep '^\[UNIQUE_RACES\]' $(OUT_ESCAPE_WCP_SA) 2>/dev/null | sed 's/^/  escape + WCP + SA : /'

	@echo ""
	@echo "====== Correctness Check: WCP vs WCP+SA unique race sets ======"
	@grep '^\[UNIQUE_RACE\]' $(OUT_WCP)    2>/dev/null | sed 's/ TRIGGERS=[0-9]*//' | sort > /tmp/_wcp.txt
	@grep '^\[UNIQUE_RACE\]' $(OUT_WCP_SA) 2>/dev/null | sed 's/ TRIGGERS=[0-9]*//' | sort > /tmp/_wcp_sa.txt
	@if diff -q /tmp/_wcp.txt /tmp/_wcp_sa.txt > /dev/null 2>&1; then \
	   echo "  WCP vs WCP+SA : ✓ IDENTICAL (SA does not affect race set)"; \
	 else \
	   echo "  WCP vs WCP+SA : ✗ DIFFER"; \
	   diff /tmp/_wcp.txt /tmp/_wcp_sa.txt | sed 's/^/    /'; \
	 fi
	@grep '^\[UNIQUE_RACE\]' $(OUT_ESCAPE_WCP)    2>/dev/null | sed 's/ TRIGGERS=[0-9]*//' | sort > /tmp/_escape_wcp.txt
	@grep '^\[UNIQUE_RACE\]' $(OUT_ESCAPE_WCP_SA) 2>/dev/null | sed 's/ TRIGGERS=[0-9]*//' | sort > /tmp/_escape_wcp_sa.txt
	@if diff -q /tmp/_escape_wcp.txt /tmp/_escape_wcp_sa.txt > /dev/null 2>&1; then \
	   echo "  escape WCP vs escape WCP+SA : ✓ IDENTICAL"; \
	 else \
	   echo "  escape WCP vs escape WCP+SA : ✗ DIFFER"; \
	   diff /tmp/_escape_wcp.txt /tmp/_escape_wcp_sa.txt | sed 's/^/    /'; \
	 fi

	@echo ""
	@echo "====== Wall Time ======"
	@grep "Launch to finish" $(OUT_WCP)           2>/dev/null | sed 's/^/  plain WCP         : /'
	@grep "Launch to finish" $(OUT_WCP_SA)        2>/dev/null | sed 's/^/  WCP + SA          : /'
	@grep "Launch to finish" $(OUT_ESCAPE_WCP)    2>/dev/null | sed 's/^/  escape WCP        : /'
	@grep "Launch to finish" $(OUT_ESCAPE_WCP_SA) 2>/dev/null | sed 's/^/  escape + WCP + SA : /'

	@echo ""
	@echo "====== First Race Report ======"
	@grep 'WCP.*LOG' $(OUT_WCP)           | head -1 | sed 's/^/  plain WCP         : /'
	@grep 'WCP.*LOG' $(OUT_WCP_SA)        | head -1 | sed 's/^/  WCP + SA          : /'
	@grep 'WCP.*LOG' $(OUT_ESCAPE_WCP)    | head -1 | sed 's/^/  escape WCP        : /'
	@grep 'WCP.*LOG' $(OUT_ESCAPE_WCP_SA) | head -1 | sed 's/^/  escape + WCP + SA : /'

# ──────────────────────────────────────────────────────────────────
# COMPARE — TSAN-based automated Python validation
# ──────────────────────────────────────────────────────────────────
compare: $(BENCH_TSAN) $(TARGET_LL) $(BENCH_WCP) $(BENCH_WCP_SA)
	@echo "========================================"
	@echo " Running Executions..."
	@echo "========================================"
	-./$(BENCH_TSAN)   2>&1 | tee $(OUT_TSAN)   > /dev/null
	-./$(BENCH_WCP)    2>&1 | tee $(OUT_WCP)    > /dev/null
	-./$(BENCH_WCP_SA) 2>&1 | tee $(OUT_WCP_SA) > /dev/null
	@echo "[Done] Logs saved to $(BUILD_DIR)/"
	@echo ""
	@echo "========================================"
	@echo " Running Automated Python Analysis..."
	@echo "========================================"
	@python3 compare_races.py $(TARGET_SRC)

# ──────────────────────────────────────────────────────────────────
# DEBUG — show instrumentation call counts in the instrumented IR
# ──────────────────────────────────────────────────────────────────
debug: $(TARGET_INST_BC)
	@echo "Disassembling instrumented bitcode..."
	llvm-dis $(TARGET_INST_BC) -o $(BUILD_DIR)/inst.ll
	@echo "Instrumentation call counts:"
	@printf "  __ft_read   : "; grep -c "call.*__ft_read"   $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_write  : "; grep -c "call.*__ft_write"  $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_lock   : "; grep -c "call.*__ft_lock"   $(BUILD_DIR)/inst.ll || echo 0
	@printf "  __ft_unlock : "; grep -c "call.*__ft_unlock" $(BUILD_DIR)/inst.ll || echo 0

# ──────────────────────────────────────────────────────────────────
# HELP
# ──────────────────────────────────────────────────────────────────
help:
	@echo "================================================================"
	@echo "          WCP Race Detector Build System"
	@echo "================================================================"
	@echo "All build artifacts are written to: ./$(BUILD_DIR)/"
	@echo ""
	@echo "Core targets:"
	@echo "  make all              Build bench_wcp and bench_wcp_sa (default)"
	@echo "  make run              Run all 4 variants and compare races + timing"
	@echo "  make debug            Show __ft_* call counts in instrumented IR"
	@echo "  make clean            Remove entire $(BUILD_DIR)/ directory"
	@echo ""
	@echo "Runtime variants:"
	@echo "  bench_wcp             Plain WCP"
	@echo "  bench_wcp_sa          WCP + Sharing Analysis"
	@echo ""
	@echo "Escape analysis:"
	@echo "  make instrument_escape"
	@echo "    instrumented_escape_wcp    Escape + WCP"
	@echo "    instrumented_escape_wcp_sa Escape + WCP + SA"
	@echo ""
	@echo "TSAN validation:"
	@echo "  make bench_tsan       Build TSAN-instrumented binary"
	@echo "  make compare          Run TSAN + WCP + WCP+SA and analyse with Python"
	@echo "  make target_ir        Emit human-readable IR for Python race mapper"
	@echo ""
	@echo "Output logs (all in $(BUILD_DIR)/):"
	@echo "  out_tsan.txt           TSAN baseline"
	@echo "  out_wcp.txt            Plain WCP"
	@echo "  out_wcp_sa.txt         WCP + SA"
	@echo "  out_escape_wcp.txt     Escape + WCP"
	@echo "  out_escape_wcp_sa.txt  Escape + WCP + SA"
	@echo "================================================================"

# ──────────────────────────────────────────────────────────────────
# CLEAN
# ──────────────────────────────────────────────────────────────────
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run debug clean help \
        bench_tsan target_ir compare instrument_escape